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
		if not matched_from_key[arm.key] then
			if vim.list_contains(arm.pattern.ft or {}, vim.bo[bufnr].filetype) then
				table.insert(matched_arms, arm)
				matched_from_key[arm.key] = true
			end
		end
	end

	return matched_arms
end

M.setup = function()
	-- Vim

	local vim_setup_arms = {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local setups = {}
			local teardowns = {}

			for _, arm in ipairs(M.matches(args.buf, vim_setup_arms)) do
				local setup = arm.value[1]
				local teardown = arm.value[2]

				table.insert(setups, setup)
				table.insert(teardowns, teardown)
			end

			for _, setup in ipairs(setups) do
				setup(args.buf)
			end

			vim.api.nvim_create_autocmd({ "BufLeave" }, {
				buffer = args.buf,
				callback = function()
					for _, setup in ipairs(setups) do
						teardown(args.buf)
					end

					return true
				end,
			})
		end,
	})

	-- Vim CD

	local vim_cd_arms = {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local arm = M.matches(args.buf, vim_cd_arms)[1]

			local enabled = arm.value

			if enabled then
				local src_dir = vim.fn.getcwd()
				local dst_dir = vim.cmd.cd("/")

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

	-- Treesitter

	local treesitter_parser_arms = {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local arm = M.matches(args.buf, treesitter_parser_arms)[1]

			local parser = arm.value

			if parser ~= nil then
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

	local treesitter_parser_folding_arms = {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local arm = M.matches(args.buf, treesitter_parser_folding_arms)[1]

			local enabled = arm.value

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

	local treesitter_parser_indenting_arms = {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local arm = M.matches(args.buf, treesitter_parser_indenting_arms)[1]

			local enabled = arm.value

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

	local lsp_server_arms = {}

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

	local lsp_server_formatting_arms = {}

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

	local conform_formatter_formatting_arms = {}

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

	local lint_linter_checking_arms = {}

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
