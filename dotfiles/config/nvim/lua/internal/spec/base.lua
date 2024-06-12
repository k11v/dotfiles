local util = require("internal.util")

return {
	{
		"nvim",
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
		opts = {
			x_servers = {}, -- User-defined
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
				require("lspconfig")[server].setup(server_opts)
			end

			vim.api.nvim_create_autocmd({ "LspAttach" }, {
				group = vim.api.nvim_create_augroup("internal_lspconfig", {}),
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
			x_packages = {},
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
		url = "https://github.com/nvim-tree/nvim-web-devicons",
		dependencies = {},
		event = nil,
	},
}
