local mod = "go_gopls_lsp_import_organizing"

-- As of 2026-02-01 note that Client:request flushes didChange notifications only for the provided buf.
-- It doesn't flush changes for other buffers, it looks like it could lead to codeAction faults.

_G.lsp_pos_from_vim_pos = function(buf, pos, offset_encoding)
	local line = vim.api.nvim_buf_get_lines(buf, pos[1] - 1, pos[1], true)[1]
	if not line then
		return { line = 0, character = 0 }
	end

	return internal_lsp_pos_from_vim_pos(line, pos, offset_encoding)
end

_G.internal_lsp_pos_from_vim_pos = function(line, pos, offset_encoding)
	local row = pos[1]
	local col = pos[2]
	local lsp_row = row - 1
	local lsp_col = vim.str_utfindex(line, offset_encoding, col, true)
	return { line = lsp_row, character = lsp_col }
end

_G.test_internal_lsp_pos_from_vim_pos = function()
	local tests = {
		{
			name = "line with single-byte characters",
			line = "text",
			pos = { 1, 3 },
			offset_encoding = "utf-16",
			want = { line = 0, character = 3 },
		},
		{
			name = "empty line",
			line = "",
			pos = { 1, 0 },
			offset_encoding = "utf-16",
			want = { line = 0, character = 0 },
		},
		{
			name = "line with multibyte characters",
			line = "text текст",
			pos = { 1, 13 },
			offset_encoding = "utf-16",
			want = { line = 0, character = 9 },
		},
	}

	for _, tt in ipairs(tests) do
		local got = internal_lsp_pos_from_vim_pos(tt.line, tt.pos, tt.offset_encoding)
		if not vim.deep_equal(got, tt.want) then
			vim.notify(
				string.format(
					"test_internal_lsp_pos_from_vim_pos/%s: got %s, want %s",
					tt.name, vim.inspect(got), vim.inspect(tt.want)
				),
				vim.log.levels.ERROR
			)
		end
	end
end

-- get_buf_cursor gets buf cursor position for any valid buffer, including hidden.
--
-- FIXME: Either get_buf_cursor or lsp_pos_from_vim_pos should solve that 
-- code_action runs on "virtual column" instead of "real column" and fails.
-- Reproduce with "in Go file go to a line with a tab, go to the end of the line, run code_action".
-- Maybe after the fix, reduce logging verbosity.
_G.get_buf_cursor = function(buf)
	buf = buf ~= 0 and buf or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(buf) then
		return { 1, 0 }
	end

	local cur_win = vim.api.nvim_get_current_win()
	local cur_buf = vim.api.nvim_win_get_buf(cur_win)
	if cur_buf == buf then
		return vim.api.nvim_win_get_cursor(cur_win)
	end

	local wins = vim.fn.win_findbuf(buf)
	if #wins > 0 then
		return vim.api.nvim_win_get_cursor(wins[1])
	end

	local pos = vim.api.nvim_buf_get_mark(buf, '"')
	if pos[1] ~= 0 then
		return pos
	end

	return { 1, 0 }
end

_G.code_action = function(client, buf, code_action_context)
	vim.validate('client', client, 'table', true)
	vim.validate('buf', buf, 'number')
	vim.validate('code_action_context', code_action_context, 'table')

	buf = buf ~= 0 and buf or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	client = client or vim.lsp.get_clients({ bufnr = buf, method = "textDocument/codeAction" })[1]
	if client == nil then
		vim.notify("code action missing client", vim.log.levels.INFO)
		return
	end

	-- Get code action.

	local code_action_params = nil
	local code_action_result = nil
	local code_action_cancel = nil

	do
		local vim_pos = get_buf_cursor(buf)
		local lsp_pos = lsp_pos_from_vim_pos(buf, vim_pos, client.offset_encoding)
		code_action_params = {
			textDocument = vim.lsp.util.make_text_document_params(buf),
			range = { start = lsp_pos, ["end"] = lsp_pos },
			context = code_action_context,
		}
	end

	do
		local ok, id = client:request(
			"textDocument/codeAction",
			code_action_params,
			function(err, ok) code_action_result = { ok = ok, err = err } end,
			buf
		)
		if ok then
			code_action_cancel = function() client:cancel_request(id) end
		else
			code_action_result = { err = {} }
		end
	end

	do
		local ok, _ = vim.wait(1000, function() return code_action_result ~= nil end, 10)
		if not ok then
			code_action_cancel()
			vim.notify("code action timeout", vim.log.levels.INFO)
			return
		end
	end

	local code_action_ok_result = nil

	do
		local err = code_action_result.err
		if err ~= nil then
			vim.notify(string.format("code action error: %s", vim.inspect(err)), vim.log.levels.INFO)
			vim.notify(string.format("code action params: %s", vim.inspect(code_action_params)), vim.log.levels.DEBUG)
			vim.notify(string.format("code action result: %s", vim.inspect(code_action_result)), vim.log.levels.DEBUG)
			return
		end
		code_action_ok_result = code_action_result.ok
	end

	local code_action = nil

	do
		if code_action_ok_result == nil or #code_action_ok_result == 0 then
			vim.notify("code action not found", vim.log.levels.INFO)
			return
		end

		if #code_action_ok_result > 1 then
			vim.notify("multiple code actions", vim.log.levels.INFO)
			return
		end

		code_action = code_action_ok_result[1]
	end

	-- Resolve code action.

	-- LSP spec is not clear about when code action should be resolved.
	-- We could interspect code action and resolve if edit or command
	-- is missing but for now resolving every time is good enough.
	if client:supports_method('codeAction/resolve') then
		local resolve_params = nil
		local resolve_result = nil
		local resolve_cancel = nil

		do
			resolve_params = code_action
		end

		do
			local ok, id = client:request(
				"codeAction/resolve",
				resolve_params,
				function(err, ok) resolve_result = { ok = ok, err = err } end,
				buf
			)
			if ok then
				resolve_cancel = function() client:cancel_request(id) end
			else
				resolve_result = { err = {} }
			end
		end

		do
			local ok, _ = vim.wait(1000, function() return resolve_result ~= nil end, 10)
			if not ok then
				resolve_cancel()
				vim.notify("code action resolve timeout", vim.log.levels.INFO)
				return
			end
		end

		local resolve_ok_result = nil

		do
			local err = resolve_result.err
			if err ~= nil then
				vim.notify(string.format("code action resolve error: %s", vim.inspect(err)), vim.log.levels.INFO)
				vim.notify(string.format("code action resolve params: %s", vim.inspect(resolve_params)), vim.log.levels.DEBUG)
				vim.notify(string.format("code action resolve result: %s", vim.inspect(resolve_result)), vim.log.levels.DEBUG)
				return
			end
			resolve_ok_result = resolve_result.ok
		end

		do
			code_action = resolve_ok_result
		end
	end

	-- Do code action.

	if code_action.edit then
		vim.lsp.util.apply_workspace_edit(code_action.edit, client.offset_encoding)
	end

	if code_action.command then
		vim.notify("code action command not supported", vim.log.levels.INFO)
		-- Code below won't work if command is executed on the client (handler never gets called).
		--
		-- local done = false
		-- client:exec_cmd(
		-- 	code_action.command,
		-- 	{ bufnr = buf }, -- TODO: maybe something better should be inserted here.
		-- 	function(err, ok) done = true end
		-- )
		--
		-- local ok, _ = vim.wait(1000, function() return done or client:is_stopped() end, 10)
		-- if not ok then
		-- 	vim.notify("code action execute command timeout", vim.log.levels.INFO)
		-- 	return
		-- end
	end
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup(mod, {}),
	pattern = "*.go",
	callback = function(args)
		client = client or vim.lsp.get_clients({
			bufnr = buf,
			name = "gopls",
			method = "textDocument/codeAction",
		})[1]
		if client == nil then
			return
		end

		code_action(client, args.buf, { diagnostics = {}, only = { "source.organizeImports" } })
	end,
})
