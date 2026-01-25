-- Variables.

-- Set leaders.
vim.g.mapleader = "<Space>"
vim.g.maplocalleader = "<Space>"

-- Disable built-in plugins.
-- Plugins osc52.lua, nvim/net.lua cannot be disabled.
-- See $VIMRUNTIME/plugin.
vim.g.editorconfig = false -- editorconfig.lua
vim.g.loaded_2html_plugin = 1 -- tohtml.lua
vim.g.loaded_gzip = 1 -- gzip.vim
vim.g.loaded_man = 1 -- man.lua
vim.g.loaded_matchit = 1 -- matchit.vim
vim.g.loaded_matchparen = 1 -- matchparen.vim
vim.g.loaded_netrw = 1 -- netrwPlugin.vim
vim.g.loaded_netrwPlugin = 1 -- netrwPlugin.vim
vim.g.loaded_remote_plugins = 1 -- rplugin.vim
vim.g.loaded_shada_plugin = 1 -- shada.vim
vim.g.loaded_spellfile_plugin = 1 -- nvim/spellcheck.lua
vim.g.loaded_tar = 1 -- tarPlugin.vim
vim.g.loaded_tarPlugin = 1 -- tarPlugin.vim
vim.g.loaded_tutor_mode_plugin = 1 -- tutor.vim
vim.g.loaded_zip = 1 -- zipPlugin.vim
vim.g.loaded_zipPlugin = 1 -- zipPlugin.vim

-- Disable built-in plugin providers.
-- See *provider*.
vim.g.loaded_node_provider = 1
vim.g.loaded_perl_provider = 1
vim.g.loaded_python3_provider = 1
vim.g.loaded_ruby_provider = 1

-- Options.

-- Disable 'wrapscan' to simplify automation with search.
-- You can wrap manually with "ggn".
vim.opt.wrapscan = false

vim.opt.timeout = false

vim.opt.signcolumn = "yes"

-- Disable 'hidden' to reduce buffer list pollution with modified buffers.
-- The default is on in Neovim and off in Vim.
--
-- When 'hidden' is disabled and buffer is abandoned,
-- it is unloaded and undo information is lost.
-- Enabling 'undofile' mitigates that.
vim.opt.hidden = false

-- Enable 'undofile' to persist undo information for unloaded buffers.
vim.opt.undofile = true

-- Other.

-- Augroup.
vim.g.augroup = vim.api.nvim_create_augroup("g", {})

-- Gopt and bopt.
vim.g.opt = {}
vim.cmd([[autocmd g FileType * lua vim.b.opt = {}]])

-- Lspconfig.
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

-- Go gopls.
local gopls_cmd = {
	vim.fn.expand("~/.local/share/mise/installs/go-golang-org-x-tools-gopls/latest/bin/gopls"),
	unpack(vim.lsp.config["gopls"].cmd, 2),
}

local gopls_on_attach
do
	local on_attach = vim.lsp.config["gopls"].on_attach or function() end
	gopls_on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr)
	end
end

vim.lsp.config("gopls", {
	cmd = gopls_cmd,
	on_attach = gopls_on_attach,
	settings = {
		gopls = {
			buildFlags = { "-tags=dev,integration" }, -- temporary
			directoryFilters = { "-.git" },
			gofumpt = true,
			renameMovesSubpackages = true, -- requires gopls >= 0.21.0
			semanticTokens = true,
			staticcheck = true,
			usePlaceholders = true,
			analyses = {
				S1011 = false, -- Use a single append to concatenate two slices
				ST1000 = false, -- Incorrect or missing package comment
				ST1003 = false, -- Poorly chosen identifier
				ST1022 = false, -- The documentation of an exported variable or constant should start with variable's name
				infertypeargs = false, -- check for unnecessary type arguments in call expressions -- temporary
				slicescontains = false, -- replace loops with slices.Contains or slices.ContainsFunc -- temporary
			},
		},
	}
})

vim.lsp.enable("gopls")

-- Go LSP formatting.
vim.cmd([[autocmd g BufWritePre *.go lua vim.lsp.buf.format({})]])

-- LSP progress.
local lsp_progress_func
do
	local progress_from_key = {}

	lsp_progress_func = function(args)
		local buffer_id = args.buf
		local client_id = args.data.client_id
		local token = args.data.params.token
		local value = args.data.params.value

		-- Get client name.
		local client = vim.lsp.get_client_by_id(client_id)
		if client == nil then
			return
		end
		local client_name = client.name

		-- Get progress key.
		local progress_key = string.format("%s:%s:%s", buffer_id, client_id, token)
		local progress_value = progress_from_key[progress_key]

		-- Get and set notification parameters.
		if value.kind == "begin" then
			if progress_value ~= nil then
				return
			end
			progress_value = {}
			progress_value.name = client.name or ""
			progress_value.title = value.title or ""
			progress_value.message = value.message or ""
			progress_value.percentage = 0
			progress_from_key[progress_key] = progress_value
		elseif value.kind == "report" then
			if progress_value == nil then
				return
			end
			progress_value.message = value.message or ""
			progress_value.percentage = value.percentage or progress_value.percentage
			progress_from_key[progress_key] = progress_value
		elseif value.kind == "end" then
			if progress_value == nil then
				return
			end
			progress_value.message = value.message or ""
			progress_value.percentage = 100
			progress_from_key[progress_key] = progress_value
		else
			return
		end

		-- Get notification.
		local notification = string.format(
			"%s: %s%s%s%s(%s%%)",
			progress_value.name,
			progress_value.title,
			progress_value.title == "" and "" or " ",
			progress_value.message,
			progress_value.message == "" and "" or " ",
			progress_value.percentage
		)

		-- Send notification.
		vim.notify(notification)
	end
end

vim.api.nvim_create_autocmd("LspProgress", { group = vim.g.augroup, callback = lsp_progress_func })

-- Search
vim.api.nvim_create_user_command("Search", function(opts)
  local s = opts.args

  -- Escape regex-special chars, then turn underscores into "." wildcards.
  local escaped = vim.fn.escape(s, [[\.^$~[]*+?(){}|]])
  local pattern = escaped:gsub("_", ".")

  -- Set search register and jump to next match.
  vim.fn.setreg("/", pattern)
  vim.cmd("normal! n")
end, { nargs = 1 })

-- Use
do
	create_use_callback = function(args_keys)
		return function(args)
			local t = vim.uv.hrtime()

			local payload = {}
			for _, k in ipairs(args_keys) do
				payload[k] = args[k]
			end
			payload["t"] = t

			-- TODO: Replace with writing to file a usefile through a buffer.
			-- Also consider executing everything after t asynchroniously.
			vim.print(payload)
		end
	end

	vim.api.nvim_create_autocmd("BufEnter", { group = vim.g.augroup, callback = create_use_callback({ "buf", "event" }) })
	vim.api.nvim_create_autocmd("BufLeave", { group = vim.g.augroup, callback = create_use_callback({ "buf", "event" }) })
end
