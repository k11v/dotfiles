-- Install `lazy`

local install_lazy = function()
	local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazy_path) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--branch=stable",
			"https://github.com/folke/lazy.nvim.git",
			lazy_path,
		})
	end
	vim.opt.rtp:prepend(lazy_path)
end

-- Create events for `lazy`

-- https://github.com/LazyVim/LazyVim/blob/864c58cae6df28c602ecb4c94bc12a46206760aa/lua/lazyvim/util/plugin.lua#L60
local create_lazy_file_event = function()
	local lazy_event = require("lazy.core.handler.event")

	lazy_event.mappings["LazyFile"] = {
		id = "LazyFile",
		event = "User",
		pattern = "LazyFile",
	}

	local events = {}
	local done = false
	local load = function()
		if #events == 0 or done then
			return
		end
		done = true
		vim.api.nvim_del_augroup_by_name("LazyFile")

		local skips = {}
		for _, event in ipairs(events) do
			skips[event.event] = skips[event.event] or lazy_event.get_augroups(event.event)
		end

		vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
		for _, event in ipairs(events) do
			if vim.api.nvim_buf_is_valid(event.buf) then
				lazy_event.trigger({
					event = event.event,
					exclude = skips[event.event],
					data = event.data,
					buf = event.buf,
				})
				if vim.bo[event.buf].filetype then
					lazy_event.trigger({
						event = "FileType",
						buf = event.buf,
					})
				end
			end
		end
		vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
		events = {}
	end
	load = vim.schedule_wrap(load)

	vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
		group = vim.api.nvim_create_augroup("LazyFile", {}),
		callback = function(event)
			table.insert(events, event)
			load()
		end,
	})
end

-- Setup modules

local setup_modules = function(modules)
	for _, module in ipairs(modules) do
		require(module).setup()
	end
end

-- Lazy load plugins

local load_plugins = function(modules)
	local plugins = {}

	for _, module in ipairs(modules) do
		vim.list_extend(plugins, require(module).get_plugins(module))
	end

	require("lazy").setup({
		spec = plugins,
		defaults = {
			lazy = true, -- TODO: Review
			version = false, -- TODO: Review
		},
		install = {
			colorscheme = { "tokyonight" },
		},
		checker = {
			enabled = true,
			-- frequency = 3600, -- TODO: Consider
		},
		performance = {
			rtp = {
				disabled_plugins = {
					"editorconfig",
					"gzip",
					"health",
					"man",
					"matchit",
					"matchparen",
					"netrwPlugin",
					-- "nvim",
					"rplugin",
					-- "shada",
					"spellfile",
					"tarPlugin",
					"tohtml",
					"tutor",
					"zipPlugin",
				},
			},
		},
	})
end

-- Execute

local enabled_modules = {
	-- Should be first
	"user.any",
	-- Could be in any order
	"user.git",
	"user.javascript",
	"user.lua",
	"user.python",
	"user.rust",
	"user.tailwind",
	"user.vue",
}

install_lazy()
create_lazy_file_event()
setup_modules(enabled_modules)
load_plugins(enabled_modules)
