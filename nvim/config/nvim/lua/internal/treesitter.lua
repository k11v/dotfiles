-- Install parsers and queries with the `nvim-treesitter-install` shell script
-- (see nvim/.bin/nvim-treesitter-install). This module is runtime only.

local mod = "internal.treesitter"
local enable_group = vim.api.nvim_create_augroup(mod .. ".enable", {})

local M = {}

--- @class internal.treesitter.Config
--- @field filetypes? string[]
--- @field folds?     boolean

local configs = {} --- @type table<string, internal.treesitter.Config>
local enabled_set = {} --- @type table<string, true>
local enable_autocmd_id = nil --- @type integer?

local function resolve(name)
	return vim.tbl_deep_extend("force", configs["*"] or {}, configs[name] or {})
end

--- Set the configuration for a parser.
--- Mirrors `vim.lsp.config`. The `"*"` name is a wildcard merged under every resolved config.
--- @param name string
--- @param cfg internal.treesitter.Config
function M.config(name, cfg)
	vim.validate("name", name, "string")
	vim.validate("cfg", cfg, "table")
	configs[name] = cfg
end

local function on_filetype(args)
	for name, _ in pairs(enabled_set) do
		local cfg = resolve(name)
		if cfg.filetypes and vim.tbl_contains(cfg.filetypes, args.match) then
			local ok = vim.treesitter.language.add(name)
			if ok then
				pcall(vim.treesitter.start, args.buf, name)
				if cfg.folds ~= false then
					local win = vim.api.nvim_get_current_win()
					vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
					vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { win = win })
					vim.api.nvim_set_option_value("foldlevel", 99, { win = win })
				end
			end
		end
	end
end

--- Enable auto-activation of a configured parser on matching filetypes.
--- Mirrors `vim.lsp.enable`. Pass `enable = false` to disable.
--- @param name string|string[]
--- @param enable? boolean
function M.enable(name, enable)
	vim.validate("name", name, { "string", "table" })
	enable = enable ~= false
	local names = type(name) == "table" and name or { name }
	for _, n in ipairs(names) do
		enabled_set[n] = enable and true or nil
	end

	if not next(enabled_set) then
		if enable_autocmd_id then
			vim.api.nvim_del_autocmd(enable_autocmd_id)
			enable_autocmd_id = nil
		end
		return
	end

	enable_autocmd_id = enable_autocmd_id
		or vim.api.nvim_create_autocmd("FileType", {
			group = enable_group,
			callback = on_filetype,
		})

	if enable and (vim.v.vim_did_enter == 1 or vim.fn.did_filetype() == 1) then
		vim.cmd.doautoall(mod .. ".enable FileType")
	end
end

--- @param name string
--- @return boolean
function M.is_enabled(name)
	return enabled_set[name] == true
end

return M
