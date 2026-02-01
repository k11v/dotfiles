local mod = "go_gopls_lsp_import_organizing"

-- get_buf_cursor gets buf cursor position for any valid buffer, including hidden.
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

_G.code_action = function()
	-- TODO: Support as a parameter.
	local buf = vim.api.nvim_get_current_buf()

	-- TODO: Support as a parameter.
	-- TODO: Support multiple.
	local client = vim.lsp.get_clients({ bufnr = buf, method = "textDocument/codeAction" })[1]
	if client == nil then
		vim.notify("code action missing client", vim.log.levels.INFO)
		return
	end

	-- REQUEST

	-- As of 2026-02-01 note that Client:request flushes didChange notifications only for the provided buf.
	-- It doesn't flush changes for other buffers, it looks like it could lead to codeAction faults.

	local codeActionParams = nil
	local codeActionResult = nil
	local codeActionCancel = nil

	do
		local pos = get_buf_cursor(buf)
		local range_params = vim.lsp.util.make_given_range_params(pos, pos, buf, client.offset_encoding)
		codeActionParams = {
			textDocument = range_params.textDocument,
			range = range_params.range,
			context = {
				diagnostics = {},
				only = nil,
				triggerKind = nil,
			},
		}
	end

	do
		local ok, id = client:request(
			"textDocument/codeAction",
			codeActionParams,
			function(err, ok) codeActionResult = { ok = ok, err = err } end,
			buf
		)
		if ok then
			codeActionCancel = function() client:cancel_request(id) end
		else
			codeActionResult = { err = {} }
		end
	end

	do
		local ok, _ = vim.wait(1000, function() return codeActionResult ~= nil end, 10)
		if not ok then
			codeActionCancel()
			vim.notify("code action timeout", vim.log.levels.INFO)
			return
		end
	end

	local codeActionOkResult = nil

	do
		local err = codeActionResult.err
		if err ~= nil then
			vim.notify(string.format("code action error: %s", vim.inspect(err)), vim.log.levels.INFO)
			return
		end
		codeActionOkResult = codeActionResult.ok
	end

	-- REQUEST

	local resolveParams = nil
	local resolveResult = nil
	local resolveCancel = nil

	do
		resolveParams = codeActionOkResult[1]
	end

	do
		local ok, id = client:request(
			"codeAction/resolve",
			resolveParams,
			function(err, ok) resolveResult = { ok = ok, err = err } end,
			buf
		)
		if ok then
			resolveCancel = function() client:cancel_request(id) end
		else
			resolveResult = { err = {} }
		end
	end

	do
		local ok, _ = vim.wait(1000, function() return resolveResult ~= nil end, 10)
		if not ok then
			resolveCancel()
			vim.notify("code action resolve timeout", vim.log.levels.INFO)
			return
		end
	end

	local resolveOkResult = nil

	do
		local err = resolveResult.err
		if err ~= nil then
			vim.notify(string.format("code action resolve error: %s", vim.inspect(err)), vim.log.levels.INFO)
			return
		end
		resolveOkResult = resolveResult.ok
	end

	return { codeActionOkResult = codeActionOkResult, resolveOkResult = resolveOkResult }

	-- if not (action.edit and action.command) and client:supports_method('codeAction/resolve') then

	-- local function apply_action(action, client, ctx)
	--   if action.edit then
	--     util.apply_workspace_edit(action.edit, client.offset_encoding)
	--   end
	--   local a_cmd = action.command
	--   if a_cmd then
	--     local command = type(a_cmd) == 'table' and a_cmd or action
	--     --- @cast command lsp.Command
	--     client:exec_cmd(command, ctx)
	--   end
	-- end


	-- -- Client:request_sync({method}, {params}, {timeout_ms}, {bufnr})
	-- client:request_sync()

	-- SEND ASYNC TO ALL
	-- Client:request({method}, {params}, {handler}, {bufnr})
	--
	-- client:request() -- textDocument/codeAction
	--

	-- SEND ASYNC TO THOSE THAT NEED RESOLVING, SAME CALLBACK
	-- Client:request({method}, {params}, {handler}, {bufnr})
	--
	-- client:request() -- codeAction/resolve
	--
	-- local client = assert(lsp.get_client_by_id(choice.ctx.client_id))
	-- local action = choice.action
	-- local bufnr = assert(choice.ctx.bufnr, 'Must have buffer number')
	--
	-- -- Only code actions are resolved, so if we have a command, just apply it.
	-- if type(action.title) == 'string' and type(action.command) == 'string' then
	--   apply_action(action, client, choice.ctx)
	--   return
	-- end
	--
	-- if action.disabled then
	--   vim.notify(action.disabled.reason, vim.log.levels.ERROR)
	--   return
	-- end
	--
	-- if not (action.edit and action.command) and client:supports_method('codeAction/resolve') then
	--   client:request('codeAction/resolve', action, function(err, resolved_action)
	--     if err then
	--       -- If resolve fails, try to apply the edit/command from the original code action.
	--       if action.edit or action.command then
	--         apply_action(action, client, choice.ctx)
	--       else
	--         vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
	--       end
	--     else
	--       apply_action(resolved_action, client, choice.ctx)
	--     end
	--   end, bufnr)
	-- else
	--   apply_action(action, client, choice.ctx)
	-- end

	-- NOW WAIT FOR ALL, INCLUDING codeAction/resolve
	-- local wait_result, reason = vim.wait(timeout_ms or 1000, function()
	-- 	return request_result ~= nil
	-- end, 10)
	-- if not wait_result then
	-- 	if request_id then
	-- 		self:cancel_request(request_id)
	-- 	end
	-- 	return nil, wait_result_reason[reason]
	-- end
	-- return request_result

	-- APPLY
	-- https://github.com/fnune/codeactions-on-save.nvim/blob/main/lua/codeactions-on-save/main.lua#L15
	-- ---@param action lsp.Command|lsp.CodeAction
	-- ---@param client vim.lsp.Client
	-- ---@param ctx lsp.HandlerContext
	-- local function apply_action(action, client, ctx)
	--   if action.edit then
	--     util.apply_workspace_edit(action.edit, client.offset_encoding)
	--   end
	--   local a_cmd = action.command
	--   if a_cmd then
	--     local command = type(a_cmd) == 'table' and a_cmd or action
	--     --- @cast command lsp.Command
	--     client:exec_cmd(command, ctx)
	--   end
	-- end
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup(mod, {}),
	pattern = "*.go",
	callback = function(args)
		vim.lsp.buf.code_action({
			context = {
				-- diagnostics = {}, -- here we don't need any diagnostics
				only = { "source.organizeImports" },
				-- triggerKind = 2, -- automatic
			},
			filter = function(_, client_id) return vim.lsp.get_client_by_id(client_id).name == "gopls" end,
			apply = true,
			-- range = { ... }, -- default is to respect selection but probably action ignores it
			-- timeout_ms = 1000, -- didn't find in the docs
			-- bufnr = args.buf, -- didn't find in the docs
		})
	end,
})
