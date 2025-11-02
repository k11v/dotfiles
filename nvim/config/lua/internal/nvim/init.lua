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

M.get_string = function(key)
	local cache_dir = vim.fn.stdpath("cache") .. "/internal"
	local cache_file = cache_dir .. "/" .. key .. ".mpack"

	-- If key is empty, return empty string.
	if key == nil or key == "" then
		return nil
	end

	-- Open file.
	local fd = vim.uv.fs_open(cache_file, "r", 438) -- 0666
	if not fd then
		return nil
	end

	-- Read content.
	local stat = vim.uv.fs_fstat(fd)
	local content = vim.uv.fs_read(fd, stat.size, 0)
	vim.uv.fs_close(fd)

	-- Return content.
	if not content then
		return nil
	end

	return content
end

M.set_string = function(key, value)
	local cache_dir = vim.fn.stdpath("cache") .. "/internal"
	local cache_file = cache_dir .. "/" .. key .. ".mpack"

	-- If key is empty, return.
	if key == nil or key == "" then
		return
	end

	-- If value is nil, remove file and return.
	if value == nil then
		vim.uv.fs_unlink(cache_file)
		return
	end

	-- Create directory.
	if vim.fn.isdirectory(cache_dir) == 0 then
		vim.fn.mkdir(cache_dir, "p")
	end

	-- Open file.
	local fd = vim.uv.fs_open(cache_file, "w", 420) -- 0644
	if not fd then
		vim.notify("can't set string", vim.log.levels.ERROR)
		return
	end

	-- Write content.
	vim.uv.fs_write(fd, value, 0)
	vim.uv.fs_close(fd)
end

M.get = function(key)
	local value = M.get_string(key)
	if value == nil then
		return nil
	end

	local ok, decoded = pcall(vim.mpack.decode, value)
	if not ok then
		return nil
	end

	return decoded
end

M.set = function(key, value)
	local encoded

	if value ~= nil then
		encoded = vim.mpack.encode(value)
	else
		encoded = nil
	end

	M.set_string(key, encoded)
end

M.equal_hash = function(key, value)
	local got_hash = vim.fn.sha256(vim.mpack.encode(value or ""))
	local want_hash = M.get_string(key) or ""

	return got_hash == want_hash
end

M.set_hash = function(key, value)
	local got_hash = vim.fn.sha256(vim.mpack.encode(value or ""))

	M.set_string(key, got_hash)
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

	-- Mise tooling

	-- Needs mise executable.

	-- TODO: Improve mise install observability.

	-- TODO: Use tool name as arm key and tool version as arm value.

	-- TODO: Implement auto-updater with
	-- `mise latest --installed -- <tool>` (to get current)
	-- and `mise latest -- <tool>` (to get available)

	local mise_tool_arms = (opts or {}).mise_tool_arms or {}

	-- Install mise tools.
	local mise_tools = {}

	for _, arm in ipairs(mise_tool_arms) do
		local tool = arm.key
		local version = arm.value

		if tool ~= "" then
			table.insert(mise_tools, tool .. "@" .. version)
		end
	end

	if #mise_tools > 0 then
		if not M.equal_hash("mise-install", mise_tools) then
			local mise_process = vim.system(vim.list_extend({ "mise", "install", "--" }, mise_tools))

			local mise_result = mise_process:wait(10 * 60 * 1000)

			if mise_result.code == 0 then
				M.set_hash("mise-install", mise_tools)
				vim.notify("installed tools with mise", vim.log.levels.INFO)
			else
				vim.notify("failed to install tools with mise", vim.log.levels.ERROR)
			end
		end
	end

	-- Hook PATH changer.
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local tools = {}

			for _, arm in ipairs(M.matches(args.buf, mise_tool_arms)) do
				local tool = arm.key
				local version = arm.value

				table.insert(tools, tool .. "@" .. version)
			end

			if #tools > 0 then
				local process = vim.system(vim.list_extend({ "mise", "bin-paths", "--" }, tools), { text = true })

				local result = process:wait(1 * 1000)

				-- TODO: Handle stderr that would contain warnings about unrecognized tools.

				-- TODO: Handle non-zero exit code.

				-- TODO: Handle colon in bin path.

				-- TODO: Handle tool priority (e.g. when we add go's bin, we might add its golangci-lint installed
				-- with "go install" and it might take over the golangci-lint tool).

				if result.code == 0 then
					local paths = vim.split(result.stdout, "\n", { trimempty = true })

					local old_path = vim.env.PATH
					local new_path = table.concat(paths, ":") .. ":" .. old_path

					vim.env.PATH = new_path

					vim.api.nvim_create_autocmd({ "BufLeave" }, {
						buffer = args.buf,
						callback = function()
							vim.env.PATH = old_path

							return true
						end,
					})
				end
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
						parser = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
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
						vim.opt_local.foldmethod = vim.opt_global.foldmethod:get()
						vim.opt_local.foldexpr = vim.opt_global.foldexpr:get()

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
						vim.opt_local.indentexpr = vim.opt_global.indentexpr:get()

						return true
					end,
				})
			end
		end,
	})

	-- LSP

	-- TODO: Consider buffers with physical files.

	-- TODO: Consider stopping LSP servers that weren't used in 1 hour.

	-- TODO: Check filetypes of the LSP config (from nvim-lspconfig)
	-- and hint that some filetypes might be extra/missing.

	local lsp_server_arms = (opts or {}).lsp_server_arms or {}

	require("mini.deps").add({ source = "https://github.com/neovim/nvim-lspconfig" })

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			local client_ids = {}

			for _, arm in ipairs(M.matches(args.buf, lsp_server_arms)) do
				local server = arm.key
				local config
				local enabled

				if type(arm.value) == "table" then
					config = vim.deepcopy(vim.lsp.config[server] or {})
					config = vim.tbl_deep_extend("force", config, arm.value)
					enabled = true
				elseif type(arm.value) == "function" then
					config = vim.deepcopy(vim.lsp.config[server] or {})
					config = arm.value(config) or {}
					enabled = true
				elseif type(arm.value) == "boolean" then
					config = vim.deepcopy(vim.lsp.config[server] or {})
					enabled = arm.value
				end

				if enabled then
					local initialized = false

					-- TODO: Maybe config.on_init could be a list of functions?
					local on_init = config.on_init or function() end
					config.on_init = function(client, init_result)
						on_init(client, init_result)
						initialized = true
					end

					local client_id = vim.lsp.start(config, {
						reuse_client = nil,
						bufnr = bufnr,
						attach = false,
					})

					local ok = vim.wait(1 * 1000, function()
						return initialized
					end, 10)

					if not ok then
						vim.lsp.stop_client(client_id, true) -- force means SIGTERM but it is probably an implementation detail
						vim.notify("failed to start LSP server: timeout exceeded", vim.log.levels.ERROR)
					end

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
					local client = vim.lsp.get_clients({ bufnr = args.buf, name = server })[1]
					if client then
						table.insert(client_ids, client.id)
					else
						vim.notify("failed to register LSP server formatting: client not found", vim.log.levels.ERROR)
					end
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
