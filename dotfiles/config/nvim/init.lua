vim.g.mapleader = " " -- Set global leader to space. Should be set before key bindings in order to take effect
vim.g.maplocalleader = " " -- Set local leader to space. Should be set before key bindings in order to take effect

vim.opt.expandtab = true -- Use the appropriate number of spaces to insert a <Tab>
vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent

vim.opt.number = true -- Print the line number in front of each line
vim.opt.relativenumber = true -- Show the line number relative to the line with the cursor in front of each line
vim.opt.cursorline = true -- Highlight the text line of the cursor
vim.opt.cursorlineopt = "number" -- Make 'cursorline' highlight only the line number of the cursor

vim.opt.listchars = { tab = "→ ", space = "·" } -- Strings to use for non-printable characters when they are shown using ':set list'

vim.opt.report = 0 -- Threshold for reporting number of lines changed. Recommended by Vim Galore

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Make wrapped lines start at the same indentation as the line they're wrapping
vim.opt.breakindent = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Save undo history
vim.opt.undofile = true

-- Decrease the time for the cursor to be considered idle
vim.opt.updatetime = 250

-- Make splits open to the right and bottom
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Enable the substitution preview
vim.opt.inccommand = "split"

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Clear the search highlight when pressing escape in Normal mode
vim.keymap.set({ "n" }, "<Esc>", function()
	vim.cmd.nohlsearch()
end, { silent = true })

-- Disable the arrow keys in Normal mode -- TODO: Remove
vim.keymap.set({ "n" }, "<Left>", "")
vim.keymap.set({ "n" }, "<Right>", "")
vim.keymap.set({ "n" }, "<Up>", "")
vim.keymap.set({ "n" }, "<Down>", "")

-- Use <C-h>, <C-j>, <C-k>, <C-l> to move between windows
vim.keymap.set({ "n" }, "<C-h>", "<C-w><C-h>")
vim.keymap.set({ "n" }, "<C-l>", "<C-w><C-l>")
vim.keymap.set({ "n" }, "<C-j>", "<C-w><C-j>")
vim.keymap.set({ "n" }, "<C-k>", "<C-w><C-k>")

-- Enable the mouse mode
vim.opt.mouse = "nvic"

-- Enable Normal mode commands in (Russian) Universal Layout
-- stylua: ignore
vim.opt.langmap = { "ЙQ", "ЦW", "УE", "КR", "ЕT", "НY", "ГU", "ШI", "ЩO", "ЗP", "Б{", "Х}", "ФA", "ЫS", "ВD", "АF", "ПG", "РH", "ОJ", "ЛK", "ДL", "Ж\\", "Э|", "ЯZ", "ЧX", "СC", "МV", "ИB", "ТN", "ЬM", "Ю`", "йq", "цw", "уe", "кr", "еt", "нy", "гu", "шi", "щo", "зp", "б[", "х]", "фa", "ыs", "вd", "аf", "пg", "рh", "оj", "лk", "дl", "ж$", "э^", "яz", "чx", "сc", "мv", "иb", "тn", "ьm", "ю&" }
vim.opt.langremap = false

vim.opt.shellcmdflag = "-i " .. vim.opt.shellcmdflag:get() -- Use interactive shell for :!

vim.opt.timeout = false -- Disable mapped key sequence timeout

vim.opt.signcolumn = "yes" -- Always show the sign column (used by LSP to show diagnostics)

vim.keymap.set({ "n", "v" }, "<leader>c", '"+c', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>C", '"+C', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>Y", '"+Y', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>D", '"+D', { silent = true })

--
-- Plugins
--

local lazy_dir = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazy_dir) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim",
		lazy_dir,
	})
end

vim.opt.rtp:prepend(lazy_dir)

require("lazy").setup({
	{
		url = "https://github.com/folke/tokyonight.nvim",
		lazy = false,
		priority = math.huge,
		config = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	{
		url = "https://github.com/nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = function()
			vim.cmd.TSUpdate()
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "query", "vim", "vimdoc" }, -- Replace Neovim's built-in parsers with nvim-treesitter's own compatible parsers -- TODO: Add other parsers via modules (e.g. the Python module should add "python", the Markdown module should add "markdown", "markdown_inline", "html", etc.)
				auto_install = true,
				highlight = { enable = true },
			})
		end,
	},
	{
		url = "https://github.com/nvim-tree/nvim-web-devicons",
	},
	{
		url = "https://github.com/nvim-lualine/lualine.nvim",
		lazy = false,
		dependencies = { "https://github.com/nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					component_separators = { left = "│", right = "│" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
	{
		url = "https://github.com/echasnovski/mini.nvim",
		lazy = false,
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		url = "https://github.com/ibhagwan/fzf-lua",
		lazy = false,
		dependencies = { "https://github.com/nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({
				fzf_bin = "sk",
				winopts = {
					border = "single",
					preview = {
						title = false,
						scrollbar = false,
						delay = 10,
					},
				},
				previewers = {
					builtin = {
						extensions = {
							["jpg"] = { "chafa", "--symbols=solid" },
							["png"] = { "chafa", "--symbols=solid" },
							["svg"] = { "chafa", "--symbols=solid" },
						},
					},
				},
			})

			vim.keymap.set({ "n" }, "<leader><leader>", function()
				require("fzf-lua").buffers()
			end, { silent = true })
			vim.keymap.set({ "n" }, "<leader>sf", function()
				require("fzf-lua").files()
			end, { silent = true })
			vim.keymap.set({ "n" }, "<leader>sg", function()
				require("fzf-lua").live_grep_native()
			end, { silent = true })
			vim.keymap.set({ "n" }, "<leader>sh", function()
				require("fzf-lua").oldfiles()
			end, { silent = true })
			vim.keymap.set({ "n" }, "<leader>srf", function()
				require("fzf-lua").files({ resume = true })
			end, { silent = true })
			vim.keymap.set({ "n" }, "<leader>srg", function()
				require("fzf-lua").live_grep_native({ resume = true })
			end, { silent = true })
			vim.keymap.set({ "n" }, "<leader>srh", function()
				require("fzf-lua").oldfiles({ resume = true })
			end, { silent = true })
			vim.keymap.set({ "n" }, "<leader>srr", function()
				require("fzf-lua").resume()
			end, { silent = true })
			vim.keymap.set({ "n" }, "<leader>srs", function()
				require("fzf-lua").builtin({ resume = true })
			end, { silent = true })
			vim.keymap.set({ "n" }, "<leader>ss", function()
				require("fzf-lua").builtin()
			end, { silent = true })
		end,
	},
	{
		url = "https://github.com/L3MON4D3/LuaSnip",
		version = "v2.*",
		lazy = false,
		build = function()
			vim.fn.system({ "make", "install_jsregexp" })
		end,
		config = function()
			require("init_luasnip_snippets")

			local maybe_expand = function()
				if not require("luasnip").expandable() then
					return false
				end
				require("luasnip").expand()
				return true
			end

			local maybe_jump = function(direction)
				if not require("luasnip").jumpable(direction) then
					return false
				end
				require("luasnip").jump(direction)
				return true
			end

			local maybe_choose = function(direction)
				if not require("luasnip").choice_active() then
					return false
				end
				require("luasnip").change_choice(direction)
				return true
			end

			vim.keymap.set({ "i", "s" }, "<Tab>", function()
				if not maybe_expand() then
					maybe_jump(1)
				end
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
				maybe_jump(-1)
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<M-Tab>", function()
				if not maybe_expand() then
					maybe_choose(1)
				end
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<S-M-Tab>", function()
				maybe_choose(-1)
			end, { silent = true })
		end,
	},
	{
		url = "https://github.com/hrsh7th/cmp-nvim-lsp",
		lazy = false,
	},
	{
		url = "https://github.com/neovim/nvim-lspconfig",
		lazy = false,
		dependencies = { "https://github.com/hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("lspconfig").pyright.setup({ capabilities = capabilities }) -- TODO: npm install -g pyright
			require("lspconfig").volar.setup({ -- TODO: npm install -g @volar/vue-language-server
				capabilities = capabilities,
				filetypes = { "javascript", "json", "typescript", "vue" },
			})
			require("lspconfig").tailwindcss.setup({ -- TODO: npm install -g @tailwindcss/language-server
				capabilities = capabilities,
				filetypes = { "css", "html", "javascript", "typescript", "vue" },
			})

			vim.keymap.set({ "n" }, "<leader>e", vim.diagnostic.open_float)
			vim.keymap.set({ "n" }, "[d", vim.diagnostic.goto_prev)
			vim.keymap.set({ "n" }, "]d", vim.diagnostic.goto_next)
			vim.keymap.set({ "n" }, "<leader>q", vim.diagnostic.setloclist)

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(event)
					vim.keymap.set({ "n" }, "<C-k>", vim.lsp.buf.signature_help, { buffer = event.buf })
					vim.keymap.set({ "n" }, "<leader>aa", function()
						-- TODO: Try code actions with `previewer=codeaction_native`
						require("fzf-lua").lsp_code_actions()
					end, { buffer = event.buf, silent = true })
					vim.keymap.set({ "n" }, "<leader>af", vim.lsp.buf.format, { buffer = event.buf })
					vim.keymap.set({ "n" }, "<leader>ar", vim.lsp.buf.rename, { buffer = event.buf })
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
					vim.keymap.set({ "n" }, "K", vim.lsp.buf.hover, { buffer = event.buf })
				end,
			})
		end,
	},
	{
		url = "https://github.com/zbirenbaum/copilot.lua",
		lazy = true,
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			vim.g.copilot_proxy = "http://127.0.0.1:1081"

			-- Manually perform `require("copilot").setup()` to activate the panel
			-- and suggestions modules only when the Copilot client is attached
			-- (which means the Copilot server has been started and configured). This
			-- is necessary for the plugin to respect the proxy setting from the very
			-- beginning.
			--
			-- See:
			--
			-- - https://github.com/zbirenbaum/copilot.lua/blob/master/lua/copilot/init.lua
			-- - https://github.com/zbirenbaum/copilot.lua/blob/master/lua/copilot/command.lua
			require("copilot.config").setup({
				panel = {
					enabled = false,
				},
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = "<M-C-y>",
						next = "<M-C-n>",
						prev = "<M-C-p>",
						dismiss = "<M-C-e>",
					},
				},
				filetypes = { ["*"] = true },
			})
			require("copilot.highlight").setup()

			vim.api.nvim_create_autocmd({ "LspAttach" }, {
				group = vim.api.nvim_create_augroup("UserCopilot", {}),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.name == "copilot" then
						require("copilot.panel").setup()
						require("copilot.suggestion").setup()
						require("copilot").setup_done = true
						return true -- Stop the autocmd from running again
					end
				end,
			})

			require("copilot.client").setup()
		end,
	},
	{
		url = "https://github.com/numToStr/Comment.nvim",
		lazy = false,
		config = function()
			require("Comment").setup() -- Provides `gc`* and `gb`* mappings
		end,
	},
	{
		url = "https://github.com/hrsh7th/nvim-cmp",
		lazy = false,
		config = function()
			require("cmp").setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
				},
			})

			vim.keymap.set({ "i" }, "<C-Space>", function()
				if not require("cmp").visible() then
					require("cmp").complete()
				end
			end, { silent = true })

			vim.keymap.set({ "i" }, "<C-n>", function()
				if require("cmp").visible() then
					require("cmp").select_next_item({ behavior = require("cmp").SelectBehavior.Insert })
				else
					require("cmp").complete()
				end
			end, { silent = true })

			vim.keymap.set({ "i" }, "<C-p>", function()
				if require("cmp").visible() then
					require("cmp").select_prev_item({ behavior = require("cmp").SelectBehavior.Insert })
				else
					require("cmp").complete()
				end
			end, { silent = true })

			vim.keymap.set({ "i" }, "<C-b>", function()
				if require("cmp").visible() then
					require("cmp").scroll_docs(-4)
				end
			end, { silent = true })

			vim.keymap.set({ "i" }, "<C-f>", function()
				if require("cmp").visible() then
					require("cmp").scroll_docs(4)
				end
			end, { silent = true })

			vim.keymap.set({ "i" }, "<C-y>", function()
				if require("cmp").visible() then
					require("cmp").confirm({ select = false })
				end
			end, { silent = true })

			vim.keymap.set({ "i" }, "<C-e>", function()
				if require("cmp").visible() then
					require("cmp").abort()
				end
			end, { silent = true })
		end,
	},
	{
		url = "https://github.com/nvim-lua/plenary.nvim",
	},
	{
		url = "https://github.com/nvimtools/none-ls.nvim",
		lazy = false,
		dependencies = { "https://github.com/nvim-lua/plenary.nvim" },
		config = function()
			require("null-ls").setup({
				sources = {
					{
						name = "ruff format",
						filetypes = { "python" },
						method = require("null-ls").methods.FORMATTING,
						generator = require("null-ls.helpers").formatter_factory({
							command = "ruff",
							args = { "format", "--no-cache", "--stdin-filename", "$FILENAME", "-" },
							to_stdin = true,
						}),
						condition = function(utils)
							return vim.fn.executable("ruff") == 1
						end,
					},
					require("null-ls").builtins.formatting.prettierd, -- npm install -g @fsouza/prettierd
					require("null-ls").builtins.formatting.stylua, -- brew install stylua
				},
				on_attach = function(client, bufnr)
					-- TODO: Review
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = vim.api.nvim_create_augroup("UserLspFormatting", {}),
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
		end,
	},
})
