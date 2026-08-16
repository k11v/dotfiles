local mod = "lua_fmt"
local group = vim.api.nvim_create_augroup(mod, {})

require("conform").formatters["stylua"] = {
	-- tool="cargo:stylua@latest"; mise install "$tool"; mise bin-paths "$tool"
	command = vim.fn.expand("~/.local/share/mise/installs/cargo-stylua/latest/bin/stylua"),
}

local conform_opts = {
	timeout_ms = 1000,
	formatters = { "stylua" },
}

local function format(opts)
	return require("conform").format(vim.tbl_deep_extend("keep", opts or {}, conform_opts))
end

local function formatexpr(opts)
	return require("conform").formatexpr(vim.tbl_deep_extend("keep", opts or {}, conform_opts))
end

vim.g.var = vim.tbl_deep_extend("force", vim.g.var, { [mod] = { formatexpr = formatexpr } })
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "lua",
	callback = function()
		vim.opt_local.formatexpr = "v:lua.vim.g.var." .. mod .. ".formatexpr()"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "lua",
	callback = function(args)
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = group,
			buffer = args.buf,
			callback = function(args)
				format({ bufnr = args.buf })
			end,
		})
	end,
})
