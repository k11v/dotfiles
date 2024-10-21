-- same as fzf.lua
local height_ratio = 0.85
local width_ratio = 0.8

local function abbreviated(path)
	path = path:gsub(os.getenv("HOME"), "~", 1)
	return path:gsub("([a-zA-Z])[a-z0-9]+", "%1") .. (path:match("[a-zA-Z]([a-z0-9]*)$") or "")
end

return {
	url = "https://github.com/nvim-tree/nvim-tree.lua",
	event = { "VeryLazy" },
	opts = {
		renderer = {
			root_folder_label = abbreviated,
		},
		view = {
			float = {
				enable = true,
				open_win_config = function()
					local screen_w = vim.opt.columns:get()
					local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
					local window_w = math.floor(screen_w * width_ratio)
					local window_h = math.floor(screen_h * height_ratio)
					local center_x = (screen_w - window_w) / 2
					local center_y = ((vim.opt.lines:get() - window_h) / 2)
						- vim.opt.cmdheight:get()
					return {
						border = "single",
						relative = "editor",
						row = center_y,
						col = center_x,
						width = window_w,
						height = window_h,
					}
				end,
			},
		},
		---@param bufnr integer
		---@return nil
		on_attach = function(bufnr)
			require("nvim-tree.api").config.mappings.default_on_attach(bufnr)

			vim.keymap.set(
				{ "n" },
				"<Esc>",
				require("nvim-tree.view").close,
				{ buffer = bufnr, desc = "tree: close", silent = true }
			)
		end,
	},
	config = function(_, opts)
		require("nvim-tree").setup(opts)

		vim.keymap.set({ "n" }, "<leader>f", function()
			require("nvim-tree.api").tree.open()
		end, { silent = true })

		-- Resize file tree when Neovim is resized.
		vim.api.nvim_create_autocmd({ "VimResized" }, {
			group = vim.api.nvim_create_augroup("NvimTreeResize", {}),
			callback = function()
				if require("nvim-tree.view").is_visible() then
					require("nvim-tree.view").close()
					require("nvim-tree.api").tree.open()
				end
			end,
		})
	end,
}
