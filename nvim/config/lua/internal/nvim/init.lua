local M = {}

-- arm.pattern
-- arm.pattern.ft - buffer's filetype is
-- arm.pattern.fp - buffer's filepath starts with
-- arm.pattern.x - environment contains program whose name is
-- arm.key
-- arm.value
M.matches = function(bufnr, arms)
	local matched_arms = {}
	local matched_from_key = {}

	for _, arm in ipairs(arms) do
		local key = arm.key

		if key == nil or not matched_from_key[key] then
			if #(arm.pattern.ft or {}) == 0 or vim.list_contains(arm.pattern.ft, vim.bo[bufnr].filetype) then
				table.insert(matched_arms, arm)

				if key ~= nil then
					matched_from_key[key] = true
				end
			end
		end
	end

	return matched_arms
end

M.setup = function(opts)
	-- Vim

	-- TODO: Implement teardown on BufLeave.

	local vim_setup_arms = (opts or {}).vim_setup_arms or {}

	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local setups = {}

			for _, arm in ipairs(M.matches(args.buf, vim_setup_arms)) do
				local setup = arm.value

				table.insert(setups, setup)
			end

			for _, setup in ipairs(setups) do
				setup(args.buf)
			end
		end,
	})

	-- Vim CD

	local vim_cd_arms = (opts or {}).vim_cd_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local enabled = false

			for _, arm in ipairs(M.matches(args.buf, vim_cd_arms)) do
				enabled = arm.value
			end

			if enabled then
				local src_dir = vim.fn.getcwd()
				local dst_dir = "/"

				local name = vim.api.nvim_buf_get_name(0) -- current buffer
				if name ~= "" then
					local project_name = vim.fs.root(name, ".git")
					if project_name ~= nil and project_name ~= "" then
						dst_dir = project_name
					end
				end

				vim.cmd.cd(dst_dir) -- current buffer

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						vim.cmd.cd(src_dir) -- current buffer

						return true
					end,
				})
			end
		end,
	})

	-- Mini Deps

	local deps_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.deps"

	if not vim.loop.fs_stat(deps_path) then
		vim.cmd('echo "Installing `mini.deps`" | redraw')
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/nvim-mini/mini.deps",
			deps_path,
		})
		vim.cmd("packadd mini.deps | helptags ALL")
		vim.cmd('echo "Installed `mini.deps`" | redraw')
	end

	require("mini.deps").setup()

	-- Treesitter

	local treesitter_arms = (opts or {}).treesitter_arms or {}

	-- Install nvim-treesitter.
	require("mini.deps").add({
		source = "https://github.com/nvim-treesitter/nvim-treesitter",
		checkout = "main",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})

	-- Install treesitter parsers.
	local treesitter_parsers = {}

	for _, arm in ipairs(treesitter_arms) do
		if type(arm.value) == "table" then
			local parsers = arm.value

			for _, parser in ipairs(parsers) do
				table.insert(treesitter_parsers, parser)
			end
		elseif type(arm.value) == "string" then
			local parser = arm.value

			table.insert(treesitter_parsers, parser)
		elseif type(arm.value) == "boolean" then
			local enabled = arm.value

			if enabled then
				local filetypes = arm.pattern.ft or {}

				for _, filetype in ipairs(filetypes) do
					table.insert(treesitter_parsers, vim.treesitter.language.get_lang(filetype))
				end
			end
		end
	end

	require("nvim-treesitter").install(treesitter_parsers):wait(10 * 60 * 1000)

	-- Start treesitter.
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local parser = ""

			for _, arm in ipairs(M.matches(args.buf, treesitter_arms)) do
				if type(arm.value) == "table" then
					local parsers = arm.value

					parser = parsers[1] or ""
				elseif type(arm.value) == "string" then
					parser = arm.value
				elseif type(arm.value) == "boolean" then
					local enabled = arm.value

					if enabled then
						parser = vim.treesitter.language.get_lang(filetype)
					end
				end
			end

			if parser ~= "" then
				vim.treesitter.start(args.buf, parser)

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						vim.treesitter.stop(args.buf)

						return true
					end,
				})
			end
		end,
	})

	-- Treesitter folding

	-- Needs treesitter.

	local treesitter_folding_arms = (opts or {}).treesitter_folding_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local enabled = false

			for _, arm in ipairs(M.matches(args.buf, treesitter_folding_arms)) do
				enabled = arm.value
			end

			if enabled then
				vim.opt_local.foldmethod = "expr"
				vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						vim.opt_local.foldmethod = vim.opt.foldmethod:get()
						vim.opt_local.foldexpr = vim.opt.foldexpr:get()

						return true
					end,
				})
			end
		end,
	})

	-- Treesitter indenting

	-- Needs treesitter.

	-- Needs nvim-treesitter.

	local treesitter_indenting_arms = (opts or {}).treesitter_indenting_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local enabled = false

			for _, arm in ipairs(M.matches(args.buf, treesitter_indenting_arms)) do
				enabled = arm.value
			end

			if enabled then
				vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						vim.opt_local.indentexpr = vim.opt.indentexpr

						return true
					end,
				})
			end
		end,
	})

	-- LSP

	-- TODO: Consider buffers with physical files.

	-- TODO: Consider stopping LSP servers that weren't used in 1 hour.

	local lsp_server_arms = (opts or {}).lsp_server_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local client_ids = {}

			for _, arm in ipairs(M.matches(args.buf, lsp_server_arms)) do
				local server = arm.key
				local enabled = arm.value

				if enabled then
					local client_id = vim.lsp.start(vim.deepcopy(vim.lsp.config[server]), {
						reuse_client = nil,
						bufnr = bufnr,
						attach = false,
					})

					table.insert(client_ids, client_id)
				end
			end

			if #client_ids > 0 then
				for _, client_id in ipairs(client_ids) do
					vim.lsp.buf_attach_client(args.buf, client_id)
				end

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						for _, client_id in ipairs(client_ids) do
							vim.lsp.buf_detach_client(args.buf, client_id)
						end

						return true
					end,
				})
			end
		end,
	})

	-- LSP formatting

	-- Needs LSP.

	local lsp_server_formatting_arms = (opts or {}).lsp_server_formatting_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local client_ids = {}

			for _, arm in ipairs(M.matches(args.buf, lsp_server_formatting_arms)) do
				local server = arm.key
				local enabled = arm.value

				if enabled then
					local client_id = vim.lsp.get_clients({ bufnr = args.buf, name = server })[1]

					table.insert(client_ids, client_id)
				end
			end

			if #client_ids > 0 then
				local autocmd = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
					buffer = args.buf,
					callback = function()
						for _, client_id in ipairs(client_ids) do
							vim.lsp.buf.format({ id = client_id })
						end
					end,
				})

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						vim.api.nvim_del_autocmd(autocmd)

						return true
					end,
				})
			end
		end,
	})

	-- Conform formatting

	local conform_formatter_formatting_arms = (opts or {}).conform_formatter_formatting_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local formatters = {}

			for _, arm in ipairs(M.matches(args.buf, conform_formatter_formatting_arms)) do
				local formatter = arm.key
				local enabled = arm.value

				if enabled then
					table.insert(formatters, formatter)
				end
			end

			if #formatters > 0 then
				local autocmd = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
					buffer = args.buf,
					callback = function()
						for _, formatter in ipairs(formatters) do
							require("conform").format({
								bufnr = args.buf,
								formatters = { formatter },
								timeout_ms = 1 * 1000,
							})
						end
					end,
				})

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						vim.api.nvim_del_autocmd(autocmd)

						return true
					end,
				})
			end
		end,
	})

	-- Lint checking

	local lint_linter_checking_arms = (opts or {}).lint_linter_checking_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local linters = {}

			for _, arm in ipairs(M.matches(args.buf, lint_linter_checking_arms)) do
				local linter = arm.key
				local enabled = arm.value

				if enabled then
					table.insert(linters, linter)
				end
			end

			if #linters > 0 then
				local autocmd = vim.api.nvim_create_autocmd({ "BufWritePost" }, {
					buffer = args.buf,
					callback = function()
						for _, linter in ipairs(linters) do
							require("lint").try_lint(linter) -- current buffer
						end
					end,
				})

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						vim.api.nvim_del_autocmd(autocmd)

						return true
					end,
				})
			end
		end,
	})
end

return M
