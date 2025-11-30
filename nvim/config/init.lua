local M = {}

M.setup = function(opts)
	require("internal.app").setup(opts)
	require("internal.vim_g").setup(opts)
	require("internal.vim_reloading").setup(opts)
	require("internal.vim_opt").setup(opts)
	require("internal.vim_directory_changing").setup(opts)
	require("internal.mise_tool_installing").setup(opts)
	require("internal.mise_tool_using").setup(opts)
	require("internal.mini_deps").setup(opts)
	require("internal.treesitter_nvim_treesitter_installing").setup(opts)
	require("internal.treesitter_parser_installing").setup(opts)
	require("internal.treesitter_starting").setup(opts)
	require("internal.treesitter_folding").setup(opts)
	require("internal.treesitter_indenting").setup(opts)
	require("internal.lsp_nvim_lspconfig_installing").setup(opts)
	require("internal.lsp_starting").setup(opts)
	require("internal.lsp_formatting").setup(opts)
	require("internal.conform_installing").setup(opts)
	require("internal.conform_formatting").setup(opts)
	require("internal.lint_installing").setup(opts)
	require("internal.lint_checking").setup(opts)
	require("internal.vim_diagnostic").setup(opts)
	require("internal.mini_files").setup(opts)
	require("internal.mini_notify").setup(opts)
	require("internal.mini_pick").setup(opts)
	require("internal.vim_keymap").setup(opts)
	require("internal.mini_clue").setup(opts)
	require("internal.mini_visits").setup(opts)
	require("internal.mini_git").setup(opts)
	require("internal.mini_diff").setup(opts)
	require("internal.mini_extra").setup(opts)
	require("internal.mini_icons").setup(opts)
end

M.setup = function(opts)
	require("internal.app").setup(opts)
	require("internal.vim_opt").setup(opts)
	require("internal.mini_deps").setup(opts)
	require("internal.lsp_nvim_lspconfig_installing").setup(opts)
	vim.lsp.enable("rust_analyzer")
	vim.cmd([[autocmd BufWritePre *.rs lua vim.lsp.buf.format({ async = false })]])

	local progress_from_key = {}
	vim.api.nvim_create_autocmd("LspProgress", {
		callback = function(args)
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
		end,
	})
end

M.setup({
	vim_opt_arms = {
		{ pattern = {}, key = "timeout", value = false },
		{ pattern = {}, key = "signcolumn", value = "yes" },
	},
	vim_directory_changing_arms = {
		{ pattern = {}, value = true },
	},
	mise_tool_arms = {
		-- { pattern = { ft = { "go" } }, key = "core:go", value = "1.24" }, -- temporary for demo purposes
		-- { pattern = { ft = { "go" } }, key = "aqua:golangci/golangci-lint", value = "1" }, -- temporary for demo purposes
		-- { pattern = {}, key = "core:go", value = "latest" },
		-- { pattern = {}, key = "aqua:golangci/golangci-lint", value = "2" },
		-- { pattern = {}, key = "go:golang.org/x/tools/gopls", value = "latest" },
		-- { pattern = {}, key = "aqua:LuaLS/lua-language-server", value = "latest" },
		-- { pattern = {}, key = "aqua:JohnnyMorganz/StyLua", value = "latest" },
	},
	treesitter_arms = {
		{ pattern = { ft = { "go" } }, value = true },
		{ pattern = { ft = { "gomod" } }, value = true },
		{ pattern = { ft = { "gosum" } }, value = true },
		{ pattern = { ft = { "gotmpl" } }, value = true },
		{ pattern = { ft = { "gowork" } }, value = true },
		{ pattern = { ft = { "markdown" } }, value = { "markdown", "markdown_inline" } },
	},
	treesitter_folding_arms = {
		-- { pattern = { ft = { "go" } }, value = true },
	},
	treesitter_indenting_arms = {
		{ pattern = { ft = { "go" } }, value = true },
	},
	lsp_server_arms = {
		-- { pattern = { ft = { "go", "gomod", "gowork", "gotmpl" } }, key = "gopls", value = true },
		-- { pattern = { ft = { "lua" } }, key = "lua_ls", value = true },
		{ pattern = { ft = { "rust", "cargo" } }, key = "rust_analyzer", value = true },
	},
	lsp_server_formatting_arms = {
		-- { pattern = { ft = { "go", "gomod", "gowork", "gotmpl" } }, key = "gopls", value = true },
	},
	conform_formatter_formatting_arms = {
		-- { pattern = { ft = { "lua" } }, key = "stylua", value = true },
	},
	lint_linter_checking_arms = {
		-- { pattern = { ft = { "go" }, root = { "go.mod" } }, key = "golangcilint", value = true },
	},
	miniclue_trigger_arms = {
		{ pattern = {}, key = { "n", "<leader>" }, value = { true, true } },
		{ pattern = {}, key = { "x", "<leader>" }, value = { true, true } },
	},
	miniclue_clue_arms = {
		{ pattern = {}, key = { "n", "<leader>b" }, value = { true, "+Buffer" } },
		{ pattern = {}, key = { "n", "<leader>e" }, value = { true, "+Explore" } },
		{ pattern = {}, key = { "n", "<leader>f" }, value = { true, "+Find" } },
		{ pattern = {}, key = { "n", "<leader>g" }, value = { true, "+Git" } },
		{ pattern = {}, key = { "x", "<leader>g" }, value = { true, "+Git" } },
		{ pattern = {}, key = { "n", "<leader>l" }, value = { true, "+Language" } },
		{ pattern = {}, key = { "x", "<leader>l" }, value = { true, "+Language" } },
	},
	vim_keymap_arms = {
		-- stylua: ignore start
		-- Buffer
		{ pattern = {}, key = { "n", "<leader>bd" }, value = { "<Cmd>bd<CR>", "Delete" } },
		{ pattern = {}, key = { "n", "<leader>bD" }, value = { "<Cmd>bd!<CR>", "Delete!" } },
		{ pattern = {}, key = { "n", "<leader>bs" }, value = { function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end, "Scratch" } },
		-- Explore
		{ pattern = {}, key = { "n", "<leader>ed" }, value = { "<Cmd>lua MiniFiles.open()<CR>", "Directory" } }, -- TODO: not togglable
		{ pattern = {}, key = { "n", "<leader>ef" }, value = { "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>", "File directory" } }, -- TODO: not togglable, fails when not real file
		{ pattern = {}, key = { "n", "<leader>en" }, value = { "<Cmd>lua MiniNotify.show_history()<CR>", "Notifications" } }, -- TODO: not togglable
		{ pattern = {}, key = { "n", "<leader>eq" }, value = { function() for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do if vim.fn.getwininfo(win_id)[1].quickfix == 1 then return vim.cmd("cclose") end end vim.cmd("copen") end, "Quickfix" } },
		-- Find
		{ pattern = {}, key = { "n", "<leader>f/" }, value = { '<Cmd>Pick history scope="/"<CR>', '"/" history' } },
		{ pattern = {}, key = { "n", "<leader>f:" }, value = { '<Cmd>Pick history scope=":"<CR>', '":" history' } },
		{ pattern = {}, key = { "n", "<leader>fa" }, value = { '<Cmd>Pick git_hunks scope="staged"<CR>', "Added hunks (all)" } },
		{ pattern = {}, key = { "n", "<leader>fA" }, value = { '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', "Added hunks (buf)" } },
		{ pattern = {}, key = { "n", "<leader>fb" }, value = { "<Cmd>Pick buffers<CR>", "Buffers" } },
		{ pattern = {}, key = { "n", "<leader>fc" }, value = { "<Cmd>Pick git_commits<CR>", "Commits (all)" } },
		{ pattern = {}, key = { "n", "<leader>fC" }, value = { '<Cmd>Pick git_commits path="%"<CR>', "Commits (buf)" } },
		{ pattern = {}, key = { "n", "<leader>fd" }, value = { '<Cmd>Pick diagnostic scope="all"<CR>', "Diagnostic workspace" } },
		{ pattern = {}, key = { "n", "<leader>fD" }, value = { '<Cmd>Pick diagnostic scope="current"<CR>', "Diagnostic buffer" } },
		{ pattern = {}, key = { "n", "<leader>ff" }, value = { "<Cmd>Pick files<CR>", "Files" } },
		{ pattern = {}, key = { "n", "<leader>fg" }, value = { "<Cmd>Pick grep_live<CR>", "Grep live" } },
		{ pattern = {}, key = { "n", "<leader>fG" }, value = { '<Cmd>Pick grep pattern="<cword>"<CR>', "Grep current word" } },
		{ pattern = {}, key = { "n", "<leader>fh" }, value = { "<Cmd>Pick help<CR>", "Help tags" } },
		{ pattern = {}, key = { "n", "<leader>fH" }, value = { "<Cmd>Pick hl_groups<CR>", "Highlight groups" } },
		{ pattern = {}, key = { "n", "<leader>fl" }, value = { '<Cmd>Pick buf_lines scope="all"<CR>', "Lines (all)" } },
		{ pattern = {}, key = { "n", "<leader>fL" }, value = { '<Cmd>Pick buf_lines scope="current"<CR>', "Lines (buf)" } },
		{ pattern = {}, key = { "n", "<leader>fm" }, value = { "<Cmd>Pick git_hunks<CR>", "Modified hunks (all)" } },
		{ pattern = {}, key = { "n", "<leader>fM" }, value = { '<Cmd>Pick git_hunks path="%"<CR>', "Modified hunks (buf)" } },
		{ pattern = {}, key = { "n", "<leader>fr" }, value = { "<Cmd>Pick resume<CR>", "Resume" } },
		{ pattern = {}, key = { "n", "<leader>fR" }, value = { '<Cmd>Pick lsp scope="references"<CR>', "References (LSP)" } },
		{ pattern = {}, key = { "n", "<leader>fs" }, value = { '<Cmd>Pick lsp scope="workspace_symbol"<CR>', "Symbols workspace" } },
		{ pattern = {}, key = { "n", "<leader>fS" }, value = { '<Cmd>Pick lsp scope="document_symbol"<CR>', "Symbols document" } },
		{ pattern = {}, key = { "n", "<leader>fv" }, value = { '<Cmd>Pick visit_paths cwd=""<CR>', "Visit paths (all)" } },
		{ pattern = {}, key = { "n", "<leader>fV" }, value = { "<Cmd>Pick visit_paths<CR>", "Visit paths (cwd)" } },
		-- Git
		{ pattern = {}, key = { "n", "<leader>ga" }, value = { "<Cmd>Git diff --cached<CR>", "Added diff" } },
		{ pattern = {}, key = { "n", "<leader>gA" }, value = { "<Cmd>Git diff --cached -- %<CR>", "Added diff buffer" } },
		{ pattern = {}, key = { "n", "<leader>gc" }, value = { "<Cmd>Git commit<CR>", "Commit" } },
		{ pattern = {}, key = { "n", "<leader>gC" }, value = { "<Cmd>Git commit --amend<CR>", "Commit amend" } },
		{ pattern = {}, key = { "n", "<leader>gd" }, value = { "<Cmd>Git diff<CR>", "Diff" } },
		{ pattern = {}, key = { "n", "<leader>gD" }, value = { "<Cmd>Git diff -- %<CR>", "Diff buffer" } },
		{ pattern = {}, key = { "n", "<leader>gl" }, value = { [[<Cmd>Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order<CR>]], "Log" } },
		{ pattern = {}, key = { "n", "<leader>gL" }, value = { [[<Cmd>Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order --follow -- %<CR>]], "Log buffer" } },
		{ pattern = {}, key = { "n", "<leader>go" }, value = { "<Cmd>lua MiniDiff.toggle_overlay()<CR>", "Toggle overlay" } },
		{ pattern = {}, key = { "n", "<leader>gs" }, value = { "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at cursor" } },
		{ pattern = {}, key = { "x", "<leader>gs" }, value = { "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at selection" } },
		-- Language
		{ pattern = {}, key = { "n", "<leader>la" }, value = { "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Actions" } },
		{ pattern = {}, key = { "n", "<leader>ld" }, value = { "<Cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostic popup" } },
		{ pattern = {}, key = { "n", "<leader>lf" }, value = { '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>', "Format" } },
		{ pattern = {}, key = { "n", "<leader>li" }, value = { "<Cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation" } },
		{ pattern = {}, key = { "n", "<leader>lh" }, value = { "<Cmd>lua vim.lsp.buf.hover()<CR>", "Hover" } },
		{ pattern = {}, key = { "n", "<leader>lr" }, value = { "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename" } },
		{ pattern = {}, key = { "n", "<leader>lR" }, value = { "<Cmd>lua vim.lsp.buf.references()<CR>", "References" } },
		{ pattern = {}, key = { "n", "<leader>ls" }, value = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Source definition" } },
		{ pattern = {}, key = { "n", "<leader>lt" }, value = { "<Cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition" } },
		{ pattern = {}, key = { "x", "<leader>lf" }, value = { '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>', "Format selection" } },
		-- Visit
		{ pattern = {}, key = { "n", '<leader>vc' }, value = { function() local sort_latest = MiniVisits.gen_sort.default({ recency_weight = 1 }) local local_opts = { cwd = '', filter = 'core', sort = sort_latest } MiniExtra.pickers.visit_paths(local_opts, { source = { name = 'Core visits (all)' } }) end, 'Core visits (all)' } },
		{ pattern = {}, key = { "n", '<leader>vC' }, value = { function() local sort_latest = MiniVisits.gen_sort.default({ recency_weight = 1 }) local local_opts = { cwd = nil, filter = 'core', sort = sort_latest } MiniExtra.pickers.visit_paths(local_opts, { source = { name = 'Core visits (cwd)' } }) end, 'Core visits (cwd)' } },
		{ pattern = {}, key = { "n", '<leader>vv' }, value = { '<Cmd>lua MiniVisits.add_label("core")<CR>', 'Add "core" label' } },
		{ pattern = {}, key = { "n", '<leader>vV' }, value = { '<Cmd>lua MiniVisits.remove_label("core")<CR>', 'Remove "core" label' } },
		{ pattern = {}, key = { "n", '<leader>vl' }, value = { '<Cmd>lua MiniVisits.add_label()<CR>', 'Add label' } },
		{ pattern = {}, key = { "n", '<leader>vL' }, value = { '<Cmd>lua MiniVisits.remove_label()<CR>', 'Remove label' } },
		-- stylua: ignore end
	},
})
