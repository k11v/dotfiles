-- - maybe we should hook onto buf creation events for most of these buffer-related things
-- - hooking onto BufEnter for "cd" makes sense, for others tho probably not so much
-- - conceptually though seems pretty good to use BufEnter/BufLeave
-- - when i switch to some buffer i expect certain behavior
-- - hm, how does this work when i use splits? does the "focus" of another buf is the same as BufEnter?
local M = {}

-- ft - buffer's filetype is
-- fp - buffer's filepath starts with
-- x - PATH executables contains
-- we match a buffer based on some criteria (ft, fp, x)
-- so should we merge or replace value?
-- more specific/less specific
local function check(condition)
	return true
end

M.vim_setup = function(condition, setup)
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function()
			if check(condition) then
				setup()
			end
		end,
	})
end

-- more specific replaces less specific
-- parser should be installed
M.treesitter_parser = function(condition, enabled, parser)
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			if check(condition) then
				vim.treesitter.start(args.buf, parser)
				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					once = true,
					callback = function()
						vim.treesitter.stop(args.buf)
					end,
				})
			end
		end,
	})
end

-- more specific replaces less specific
-- treesitter parser only validated, it is not started
-- treesitter should be started
M.treesitter_parser_folding = function(condition, enabled)
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			if check(condition) then
				vim.opt_local.foldmethod = "expr"
				vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end
		end,
	})
end

-- more specific replaces less specific
-- treesitter parser only validated, it is not started
-- treesitter should be started
M.treesitter_parser_indenting = function(condition, enabled)
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			if check(condition) then
				vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end,
	})
end

-- more specific replaces less specific
-- server should be installed and configured
-- based on vim.lsp.start impl (not docs), it should still use default reuse_client with attach == false
-- TODO: hopping often between files in different projects will lead to a lot of unused LSPs without attached files
-- we could keep a table of recently used LSPs (based on attach/detach usage times) and stop LSPs on attach/detach
-- that were used more than 1 hour ago
-- TODO: perhaps we should do this only for real buffers (that have physical files)
M.lsp_server = function(condition, server, enabled)
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			if check(condition) then
				local client_id =
					vim.lsp.start(vim.deepcopy(vim.lsp.config[server]), { reuse_client = nil, attach = false })
				vim.lsp.buf_attach_client(args.buf, client_id)
				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					once = true,
					callback = function()
						vim.lsp.buf_detach_client(args.buf, client_id)
					end,
				})
			end
		end,
	})
end

-- more specific replaces less specific
-- server should be installed and configured
M.lsp_server_formatting = function(condition, server, enabled)
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			if check(condition) then
				local autocmd_id = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
					buffer = args.buf,
					callback = function()
						local client_id = vim.lsp.get_clients({ bufnr = args.buf, name = server })[1]
						vim.lsp.buf.format({ id = client_id })
					end,
				})
				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					once = true,
					callback = function()
						vim.api.nvim_del_autocmd(autocmd_id)
					end,
				})
			end
		end,
	})
end

M.lint_linter_diagnostic = function(condition, linter, enabled)
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			if check(condition) then
				local autocmd_id = vim.api.nvim_create_autocmd({ "BufWritePost" }, {
					buffer = args.buf,
					callback = function()
						require("lint").try_lint(linter) -- current buffer
					end,
				})
				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					once = true,
					callback = function()
						vim.api.nvim_del_autocmd(autocmd_id)
					end,
				})
			end
		end,
	})
end

M.conform_formatter_formatting = function(condition, formatter, enabled)
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			if check(condition) then
				local autocmd_id = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
					buffer = args.buf,
					callback = function()
						require("conform").format({
							bufnr = args.buf,
							formatters = { formatter },
							timeout_ms = 1 * 1000,
						})
					end,
				})
				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					once = true,
					callback = function()
						vim.api.nvim_del_autocmd(autocmd_id)
					end,
				})
			end
		end,
	})
end

return M
