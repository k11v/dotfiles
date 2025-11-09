local M = {}

-- arm.pattern
-- arm.pattern.ft - buffer's filetype is
-- arm.pattern.fp - buffer's filepath starts with
-- arm.pattern.root - buffer's filepath is inside a directory whose name is
-- arm.pattern.x - environment contains program whose name is
-- arm.key
-- arm.value
M.matches = function(bufnr, arms)
	local matched_arms = {}
	local matched_from_key = {}

	for _, arm in ipairs(arms) do
		local key
		if type(arm.key) == "string" then
			key = arm.key
		elseif type(arm.key) == "table" then
			key = vim.json.encode(arm.key) -- TODO: Optimize table key.
		else
			key = ""
		end

		if not matched_from_key[key] then
			local ft_matched = false
			local ft = arm.pattern.ft or {}
			if #ft > 0 then
				if vim.list_contains(ft, vim.bo[bufnr].filetype) then
					ft_matched = true
				end
			else
				ft_matched = true
			end

			local root_matched = false
			local root = arm.pattern.root or {}
			if #root > 0 then
				local name = vim.api.nvim_buf_get_name(bufnr)
				if name ~= "" then
					local root_name = vim.fs.root(name, root)
					if root_name ~= nil and root_name ~= "" then
						root_matched = true
					end
				end
			else
				root_matched = true
			end

			local matched = ft_matched and root_matched
			if matched then
				table.insert(matched_arms, arm)

				matched_from_key[key] = true
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

M.system_echo_sync = function(cmd, opts)
	local obj = nil
	local echo = {}
	local i = 0

	opts = vim.tbl_deep_extend("force", {}, opts or {}, {
		text = true,
		stdout = function(_, data)
			if data then
				table.insert(echo, { "| " .. data })
			end
		end,
		stderr = function(_, data)
			if data then
				table.insert(echo, { "| " .. data, "ErrorMsg" })
			end
		end,
	})

	local on_exit = function(o)
		obj = o
	end

	vim.system(cmd, opts, on_exit)

	while true do
		local done = obj ~= nil

		local j = #echo
		while i < j do
			i = i + 1
			vim.api.nvim_echo({ echo[i] }, true, {})
		end

		if done then
			break
		end

		vim.wait(10)
	end

	return obj
end

M.package_contains = function(p, subpkg)
	if string.sub(subpkg, 1, #p) == p then
		local n = string.sub(subpkg, #p + 1, #p + 1)
		if n == "." or n == "" then
			return true
		end
	end
	return false
end

M.data = {}
M.data.teardowns = {}

M.setup = function(opts)
	local teardowns = M.data.teardowns
	M.data.teardowns = {}

	for _, teardown in ipairs(teardowns) do
		teardown()
	end

	-- Vim g

	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- Vim BufEnterPre

	-- OK.

	vim.api.nvim_create_autocmd("BufEnter", {
		group = vim.api.nvim_create_augroup("internal.vim_buf_enter_pre", {}),
		callback = function(args)
			vim.api.nvim_exec_autocmds({ "User" }, { pattern = "BufEnterPre " .. args.buf, modeline = false })
		end,
	})

	-- Vim reloading

	-- OK.

	vim.api.nvim_create_autocmd("BufEnter", {
		group = vim.api.nvim_create_augroup("internal.vim_reloading", {}),
		callback = function(args)
			local dirname = vim.fn.stdpath("config")
			local handle = vim.uv.new_fs_event()

			handle:start(
				dirname,
				{ recursive = true },
				vim.schedule_wrap(function(err, filename, _)
					if err then
						vim.notify("failed to watch " .. dirname .. ": " .. err, vim.log.levels.ERROR)

						return
					end

					for k in pairs(package.loaded) do
						if M.package_contains("internal", k) then
							package.loaded[k] = nil
						end
					end

					vim.cmd("source $MYVIMRC")

					vim.api.nvim_exec_autocmds({ "BufLeave" }, { buffer = args.buf, modeline = false })
					vim.api.nvim_exec_autocmds({ "BufEnter" }, { buffer = args.buf, modeline = false })

					vim.notify("reloaded", vim.log.levels.INFO)
				end)
			)

			vim.api.nvim_create_autocmd({ "BufLeave" }, {
				buffer = args.buf,
				callback = function()
					handle:stop()

					return true
				end,
			})
		end,
	})

	-- Vim opt

	-- OK.

	local vim_opt_arms = (opts or {}).vim_opt_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.vim_opt", {}),
		callback = function(args)
			local vim_opts = {}

			for _, arm in ipairs(M.matches(args.buf, vim_opt_arms)) do
				local name = arm.key
				local value = arm.value

				table.insert(vim_opts, { name = name, value = value })
			end

			for _, o in ipairs(vim_opts) do
				vim.opt_local[o.name] = o.value -- current buffer
			end

			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "BufEnterPre " .. args.buf,
				callback = function()
					for _, o in ipairs(vim_opts) do
						vim.opt_local[o.name] = vim.opt_global[o.name]:get() -- current buffer
					end

					return true
				end,
			})
		end,
	})

	-- Vim directory changing

	-- OK.

	local vim_directory_changing_arms = (opts or {}).vim_directory_changing_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.vim_directory_changing", {}),
		callback = function(args)
			local enabled = false

			for _, arm in ipairs(M.matches(args.buf, vim_directory_changing_arms)) do
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

	-- Mise tool installing

	-- Uses mise executable.

	-- TODO: Mise tool updating (see `mise latest --installed -- <tool>` and `mise latest -- <tool>`).

	-- OK.

	local mise_tool_arms = (opts or {}).mise_tool_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.mise_tool_installing", {}),
		callback = function(_)
			local tools = {}

			for _, arm in ipairs(mise_tool_arms) do
				local name = arm.key
				local version = arm.value

				table.insert(tools, name .. "@" .. version)
			end

			if #tools > 0 then
				if not M.equal_hash("mise-install", tools) then
					vim.notify("installing mise tools", vim.log.levels.INFO)

					local mise_result = M.system_echo_sync(vim.list_extend({ "mise", "install", "--" }, tools), {
						timeout = 10 * 60 * 1000,
					})

					if mise_result.code == 0 then
						M.set_hash("mise-install", tools)
						vim.notify("installed mise tools", vim.log.levels.INFO)
					else
						vim.notify("failed to install mise tools", vim.log.levels.ERROR)
					end
				end
			end

			return true
		end,
	})

	-- Mise tool using

	-- Uses mise executable.

	-- FIXME: If "go" tool's bin is before "golangci-lint" tool's bin in PATH,
	-- "go" tool's bin has "golangci-lint" (e.g. it was installed with "go install"),
	-- then "golangci-lint" from "go" will be used over "golangci-lint" from "golangci-lint".

	-- OK.

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.mise_tool_using", {}),
		callback = function(args)
			local tools = {}

			for _, arm in ipairs(M.matches(args.buf, mise_tool_arms)) do
				local name = arm.key
				local version = arm.value

				table.insert(tools, name .. "@" .. version)
			end

			if #tools > 0 then
				local obj = vim.system(vim.list_extend({ "mise", "bin-paths", "--" }, tools), { text = true })

				local res = obj:wait(1 * 1000)

				if res.code == 0 and #res.stderr == 0 and not string.find(res.stdout, ":") then
					local bin_paths = vim.split(res.stdout, "\n", { trimempty = true })
					local old_path = vim.env.PATH
					local new_path = table.concat(bin_paths, ":") .. ":" .. old_path

					vim.env.PATH = new_path

					vim.api.nvim_create_autocmd({ "BufLeave" }, {
						buffer = args.buf,
						callback = function()
							vim.env.PATH = old_path

							return true
						end,
					})
				else
					vim.notify("failed to use mise tools: " .. res.stderr, vim.log.levels.ERROR)
				end
			end
		end,
	})

	-- Vim mini.deps installing

	-- Uses git executable.

	-- NOT OK.

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.vim_mini_deps_installing", {}),
		callback = function(_)
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

			return true
		end,
	})

	-- Treesitter nvim-treesitter installing

	-- NOT OK.

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.treesitter_nvim_treesitter_installing", {}),
		callback = function(_)
			require("mini.deps").add({
				source = "https://github.com/nvim-treesitter/nvim-treesitter",
				checkout = "main",
				hooks = {
					post_checkout = function()
						vim.cmd("TSUpdate")
					end,
				},
			})

			return true
		end,
	})

	-- Treesitter parser installing

	-- OK.

	local treesitter_arms = (opts or {}).treesitter_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.treesitter_parser_installing", {}),
		callback = function(_)
			local parsers = {}

			for _, arm in ipairs(treesitter_arms) do
				local arm_parsers

				if type(arm.value) == "table" then
					arm_parsers = arm.value
				elseif type(arm.value) == "string" then
					arm_parsers = { arm.value }
				elseif type(arm.value) == "boolean" then
					if arm.value then
						arm_parsers = {}
						for _, filetype in ipairs(arm.pattern.ft or {}) do
							table.insert(arm_parsers, vim.treesitter.language.get_lang(filetype))
						end
					end
				end

				for _, arm_parser in ipairs(arm_parsers) do
					table.insert(parsers, arm_parser)
				end
			end

			if #parsers > 0 then
				require("nvim-treesitter").install(parsers):wait(10 * 60 * 1000)
			end

			return true
		end,
	})

	-- Treesitter starting

	-- OK.

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.treesitter_starting", {}),
		callback = function(args)
			local parser = ""

			for _, arm in ipairs(M.matches(args.buf, treesitter_arms)) do
				if type(arm.value) == "table" then
					parser = arm.value[1] or ""
				elseif type(arm.value) == "string" then
					parser = arm.value
				elseif type(arm.value) == "boolean" then
					if arm.value then
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

	-- Uses treesitter starting (?).

	-- OK.

	local treesitter_folding_arms = (opts or {}).treesitter_folding_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.treesitter_folding", {}),
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

	-- Uses treesitter starting (?).

	-- Uses nvim-treesitter.

	-- OK.

	local treesitter_indenting_arms = (opts or {}).treesitter_indenting_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.treesitter_indenting", {}),
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

	-- LSP nvim-lspconfig installing

	-- NOT OK.

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.lsp_nvim_lspconfig_installing", {}),
		callback = function(_)
			require("mini.deps").add({ source = "https://github.com/neovim/nvim-lspconfig" })

			return true
		end,
	})

	-- LSP starting

	-- TODO: Consider buffers with physical files.

	-- TODO: Consider stopping LSP servers that weren't used in 1 hour.

	-- TODO: Check filetypes of the LSP config (from nvim-lspconfig)
	-- and hint that some filetypes might be extra/missing.

	-- NOT OK.

	local lsp_server_arms = (opts or {}).lsp_server_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.lsp_starting", {}),
		callback = function(args)
			local client_ids = {}
			local initialized_from_i = {}

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
					-- TODO: Maybe config.on_init could be a list of functions?
					local i = #client_ids + 1
					initialized_from_i[i] = false
					local on_init = config.on_init or function() end
					config.on_init = function(client, init_result)
						on_init(client, init_result)
						initialized_from_i[i] = true
					end

					local client_id = vim.lsp.start(config, {
						reuse_client = nil,
						bufnr = bufnr,
						attach = false,
					})

					if vim.lsp.get_client_by_id(client_id).initialized then
						initialized_from_i[i] = true
					end

					table.insert(client_ids, client_id)
				end
			end

			if #client_ids > 0 then
				local ok = vim.wait(1 * 1000, function()
					local initialized = true
					for i = 1, #client_ids do
						initialized = initialized and initialized_from_i[i]
					end
					return initialized
				end, 10)

				if not ok then
					for _, client_id in ipairs(client_ids) do
						vim.lsp.stop_client(client_id, true) -- force means SIGTERM but it is probably an implementation detail
					end
					vim.notify("failed to start LSP servers: timeout exceeded", vim.log.levels.ERROR)
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

	-- Uses LSP starting.

	-- OK.

	local lsp_server_formatting_arms = (opts or {}).lsp_server_formatting_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.lsp_formatting", {}),
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
						vim.notify("failed to format with LSP server: client not found", vim.log.levels.ERROR)
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

	-- TODO: Improve UX when formatter name is misspelled or nonexistent.
	-- Right now it sends errors to messages.
	-- Ideally we don't show any errors and a command like "doctor" tells what's wrong.

	-- TODO: Improve UX when formatter command is not installed.

	-- TODO: The PWD where the formatter is started might be important.

	-- OK.

	local conform_formatter_formatting_arms = (opts or {}).conform_formatter_formatting_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.conform_nvim_installing", {}),
		callback = function(_)
			require("mini.deps").add({ source = "https://github.com/stevearc/conform.nvim" })

			return true
		end,
	})

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.conform_formatting", {}),
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

	-- TODO: Improve UX when linter name is misspelled or nonexistent.
	-- Right now it sends errors to messages.
	-- Ideally we don't show any errors and a command like "doctor" tells what's wrong.

	-- TODO: Improve UX when linter command is not installed.

	-- TODO: The PWD where the linter is started might be important.

	-- OK.

	local lint_linter_checking_arms = (opts or {}).lint_linter_checking_arms or {}

	do
		require("mini.deps").add({ source = "https://github.com/mfussenegger/nvim-lint" })

		require("lint")

		-- No teardown.
	end

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.lint_checking", {}),
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

	-- Vim diagnostic

	do
		local old_config = vim.diagnostic.config(nil)

		vim.diagnostic.config({
			underline = { severity = { min = "HINT", max = "ERROR" } }, -- Show all diagnostics as underline
			virtual_text = { severity = { min = "ERROR", max = "ERROR" } }, -- Show more details immediately for errors
			signs = { severity = { min = "WARN", max = "ERROR" }, priority = 100 }, -- Show signs for warnings and errors
		})

		table.insert(M.data.teardowns, function()
			vim.diagnostic.config(old_config)
		end)
	end

	-- Mini files

	do
		require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.files" })

		require("mini.files").setup({})
	end

	-- Mini notify

	do
		require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.notify" })

		require("mini.notify").setup({})
	end

	-- Mini pick

	do
		require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.pick" })

		require("mini.pick").setup({})
	end

	-- Vim keymap

	local vim_keymap_arms = (opts or {}).vim_keymap_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.vim_keymap", {}),
		callback = function(args)
			local keymaps = {}

			for _, arm in ipairs(M.matches(args.buf, vim_keymap_arms)) do
				local mode = arm.key[1]
				local lhs = arm.key[2]
				local rhs = arm.value[1]
				local desc = arm.value[2]

				if type(rhs) == "string" or type(rhs) == "function" then
					table.insert(keymaps, { mode = mode, lhs = lhs, rhs = rhs, desc = desc })
				end
			end

			for _, k in ipairs(keymaps) do
				vim.keymap.set(k.mode, k.lhs, k.rhs, { desc = k.desc, buffer = args.buf })
			end

			vim.api.nvim_create_autocmd({ "BufLeave" }, {
				buffer = args.buf,
				callback = function()
					for _, k in ipairs(keymaps) do
						vim.keymap.del(k.mode, k.lhs, { buffer = args.buf })
					end

					return true
				end,
			})
		end,
	})

	-- Mini clue

	local miniclue_clue_arms = (opts or {}).miniclue_clue_arms or {}
	local miniclue_trigger_arms = (opts or {}).miniclue_trigger_arms or {}

	do
		require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.clue" })

		require("mini.clue").setup({
			clues = nil, -- dynamic
			triggers = nil, -- dynamic
			window = { delay = 0 },
		})

		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			group = vim.api.nvim_create_augroup("internal.miniclue", {}),
			callback = function(args)
				local clues = {}

				for _, arm in ipairs(M.matches(args.buf, miniclue_clue_arms)) do
					local mode = arm.key[1]
					local lhs = arm.key[2]
					local rhs = arm.value[1]
					local desc = arm.value[2]

					table.insert(clues, { mode = mode, keys = lhs, desc = desc })
				end

				local triggers = {}

				for _, arm in ipairs(M.matches(args.buf, miniclue_trigger_arms)) do
					local mode = arm.key[1]
					local lhs = arm.key[2]
					local rhs = arm.value[1]
					local desc = arm.value[2]

					table.insert(triggers, { mode = mode, keys = lhs })
				end

				vim.b[args.buf].miniclue_config = {
					clues = clues,
					triggers = triggers,
					window = nil, -- static
				}

				require("mini.clue").ensure_buf_triggers(args.buf)
			end,
		})
	end

	-- Mini visits

	do
		require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.visits" })

		require("mini.visits").setup({})
	end

	-- Mini git

	do
		require("mini.deps").add({ source = "https://github.com/nvim-mini/mini-git" })

		require("mini.git").setup()
	end

	-- Mini diff

	do
		require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.diff" })

		require("mini.diff").setup({
			view = { style = "sign", priority = 100 },
		})
	end

	-- Mini extra

	do
		require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.extra" })

		require("mini.extra").setup({})
	end

	-- Mini icons

	do
		require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.icons" })

		require("mini.icons").setup({})
	end
end

return M
