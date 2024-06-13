local util = require("internal.util")

return {
	{
		name = "nvim",
		dir = vim.fn.stdpath("config"),
		opts = {
			x_inits = {
				{
					"*",
					function()
						vim.g.loaded_node_provider = 0
						vim.g.loaded_perl_provider = 0
						vim.g.loaded_python3_provider = 0
						vim.g.loaded_ruby_provider = 0

						vim.opt.breakindent = true
						vim.opt.colorcolumn = { "80" }
						vim.opt.cursorline = true
						vim.opt.cursorlineopt = "number"
						vim.opt.expandtab = true
						vim.opt.ignorecase = true
						vim.opt.inccommand = "split"
						vim.opt.mouse = "a"
						vim.opt.number = true
						vim.opt.report = 0
						vim.opt.scrolloff = 10
						vim.opt.shiftwidth = 4
						vim.opt.showmode = false
						vim.opt.signcolumn = "yes"
						vim.opt.shortmess:append({ I = true })
						vim.opt.smartcase = true
						vim.opt.softtabstop = 4
						vim.opt.splitbelow = true
						vim.opt.splitright = true
						vim.opt.tabstop = 4
						vim.opt.timeout = false
						vim.opt.undofile = true
						vim.opt.updatetime = 250

						vim.keymap.set({ "n" }, "<Esc>", function()
							vim.cmd.nohlsearch()
						end, { silent = true })

						vim.keymap.set({ "n", "v" }, ",", '"+', { silent = true })
					end,
				},
			},
		},
	},
	{
		url = "https://github.com/ibhagwan/fzf-lua",
		dependencies = { "nvim-web-devicons" },
		event = "VeryLazy",
		opts = {
			winopts = {
				border = "single",
				preview = {
					title = false,
					scrollbar = false,
					delay = 10,
				},
			},
		},
		config = function(_, opts)
			require("fzf-lua").setup(opts)

			vim.keymap.set({ "n" }, "<leader>sL", function()
				require("fzf-lua").live_grep_native()
			end, { silent = true })

			vim.keymap.set({ "n" }, "<leader>sb", function()
				require("fzf-lua").buffers()
			end, { silent = true })

			vim.keymap.set({ "n" }, "<leader>sf", function()
				require("fzf-lua").files()
			end, { silent = true })

			vim.keymap.set({ "n" }, "<leader>sh", function()
				require("fzf-lua").oldfiles()
			end, { silent = true })

			vim.keymap.set({ "n" }, "<leader>sl", function()
				require("fzf-lua").grep_curbuf()
			end, { silent = true })

			vim.keymap.set({ "n" }, "<leader>ss", function()
				require("fzf-lua").builtin()
			end, { silent = true })
		end,
	},
	{
		url = "https://github.com/neovim/nvim-lspconfig",
		dependencies = { "fzf-lua" },
		event = "LazyFile",
		opts_extend = { "x_servers.efm.x_tools" },
		opts = {
			x_servers = {
				efm = {
					x_tools = {},
					-- x_on_attach = {
					-- 	["*"] = function() end,
					-- },
					settings = {
						rootMarkers = { ".git/" },
						init_options = {
							documentFormatting = true,
							documentRangeFormatting = true,
						},
					},
				},
			},
		},
		config = function(_, opts)
			local default_server_opts = {
				capabilities = vim.tbl_deep_extend(
					"force",
					{},
					vim.lsp.protocol.make_client_capabilities()
					-- require("cmp_nvim_lsp").default_capabilities() -- TODO
				),
			}

			for server, server_opts in pairs(opts.x_servers) do
				local server_opts = vim.tbl_deep_extend("force", default_server_opts, server_opts)

				if server == "efm" then
					local language_to_tools = {}
					for _, language_and_tool in ipairs(server_opts.x_tools) do
						local language, tool = language_and_tool[1], language_and_tool[2]
						language_to_tools[language] = language_to_tools[language] or {}
						table.insert(language_to_tools[language], tool)
					end
					server_opts.x_tools = nil

					server_opts = vim.tbl_deep_extend("force", server_opts, {
						filetypes = vim.tbl_keys(language_to_tools),
						settings = {
							languages = language_to_tools,
						},
					})
				end

				if server_opts.x_on_attach then
					local x_on_attach = server_opts.x_on_attach

					server_opts = vim.tbl_deep_extend("force", server_opts, {
						on_attach = function(client, bufnr)
							local ft = vim.bo[bufnr].filetype
							local handler = x_on_attach[ft] or x_on_attach["*"] or function() end
							handler(client, bufnr)
						end,
					})
				end

				require("lspconfig")[server].setup(server_opts)
			end

			vim.api.nvim_create_autocmd({ "LspAttach" }, {
				group = vim.api.nvim_create_augroup("internal_lspconfig_lspattach", {}),
				callback = function(event)
					vim.keymap.set({ "n" }, "<leader>e", function()
						vim.diagnostic.open_float()
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "[d", function()
						vim.diagnostic.goto_prev()
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "]d", function()
						vim.diagnostic.goto_next()
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "<leader>q", function()
						vim.diagnostic.setloclist()
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "K", function()
						vim.lsp.buf.hover()
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "<leader>aa", function()
						require("fzf-lua").lsp_code_actions()
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "<leader>af", function()
						vim.lsp.buf.format()
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "<leader>ar", function()
						vim.lsp.buf.rename()
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "gD", function()
						require("fzf-lua").lsp_declarations({ jump_to_single_result = true })
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "gd", function()
						require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "gi", function()
						require("fzf-lua").lsp_implementations({ jump_to_single_result = true })
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "gr", function()
						require("fzf-lua").lsp_references()
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "gt", function()
						require("fzf-lua").lsp_typedefs({ jump_to_single_result = true })
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "gs", function()
						require("fzf-lua").lsp_document_symbols()
					end, { buffer = event.buf, silent = true })

					vim.keymap.set({ "n" }, "gS", function()
						require("fzf-lua").lsp_live_workspace_symbols()
					end, { buffer = event.buf, silent = true })

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd({ "BufWritePre" }, {
							group = vim.api.nvim_create_augroup(
								"internal_lspconfig_bufwritepre",
								{}
							),
							buffer = event.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
								vim.diagnostic.show() -- HACK: https://github.com/neovim/neovim/issues/25014
							end,
						})
					end
				end,
			})
		end,
	},
	{
		url = "https://github.com/williamboman/mason.nvim",
		dependencies = {},
		event = "VeryLazy",
		opts_extend = { "x_packages" },
		opts = {
			x_packages = {
				"efm",
			},
			PATH = "skip",
		},
		init = function()
			vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH
		end,
		config = function(_, opts)
			require("mason").setup(opts)

			opts.x_packages = util.without_duplicates(opts.x_packages)

			local registry = require("mason-registry")
			registry.refresh(function()
				local is_mason_open = false
				for _, name in ipairs(opts.x_packages) do
					local p = registry.get_package(name)
					if not p:is_installed() then
						if not is_mason_open then
							vim.cmd.Mason()
							is_mason_open = true
						end
						p:install()
					end
				end
			end)
		end,
	},
	{
		url = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "v1.x.x",
		dependencies = { "nvim-treesitter-textobjects" },
		event = "LazyFile",
		opts_extend = { "x_parsers" },
		opts = {
			x_parsers = { "c", "lua", "query", "vim", "vimdoc" },
			auto_install = true,
			highlight = { enable = true },
			incremental_selection = { enable = true },
			indent = { enable = true },
			textobjects = {
				select = {
					enable = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
					include_surrounding_whitespace = true,
				},
			},
		},
		build = function()
			vim.cmd.TSUpdate()
		end,
		config = function(_, opts)
			opts.ensure_installed = util.without_duplicates(opts.x_parsers)
			opts.x_parsers = nil

			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {},
		event = nil,
	},
	{
		url = "https://github.com/creativenull/efmls-configs-nvim",
		version = "v1.x.x",
		dependencies = {},
		lazy = false,
	},
	{
		url = "https://github.com/nvim-tree/nvim-web-devicons",
		dependencies = {},
		event = nil,
	},
}
