local cmp_icons = {
	Namespace = "󰌗",
	Text = "󰉿",
	Method = "󰆧",
	Function = "󰆧",
	Constructor = "",
	Field = "󰜢",
	Variable = "󰀫",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "󰑭",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈚",
	Reference = "󰈇",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "󰙅",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "󰊄",
	Table = "",
	Object = "󰅩",
	Tag = "",
	Array = "[]",
	Boolean = "",
	Number = "",
	Null = "󰟢",
	String = "󰉿",
	Calendar = "",
	Watch = "󰥔",
	Package = "",
	Copilot = "",
	Codeium = "",
	TabNine = "",
}

local function make_cmp_border(hl)
	return {
		{ "┌", hl },
		{ "─", hl },
		{ "┐", hl },
		{ "│", hl },
		{ "┘", hl },
		{ "─", hl },
		{ "└", hl },
		{ "│", hl },
	}
end

return {
	{
		name = "nvim",
		dir = vim.fn.stdpath("config"),
		opts = {
			x_inits = {
				{
					["*"] = function()
						vim.diagnostic.config({ float = { border = "single" } })
						vim.lsp.handlers["textDocument/hover"] = (
							vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
						)
						vim.lsp.handlers["textDocument/signatureHelp"] = (
							vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
						)
					end,
				},
			},
		},
	},
	{
		"nvim-lspconfig",
		opts = {
			x_inits = {
				function()
					require("lspconfig.ui.windows").default_options = { border = "single" }
				end,
			},
		},
	},
	{
		"nvim-cmp",
		opts = {
			window = {
				completion = {
					border = make_cmp_border(nil),
					side_padding = 0,
					winhighlight = "Normal:CmpPmenu,CursorLine:Visual",
					scrollbar = false,
				},
				documentation = {
					border = make_cmp_border(nil),
					winhighlight = "Normal:CmpDoc",
				},
			},
			formatting = {
				fields = { "abbr", "kind", "menu" },
				format = function(_, item)
					local icon = cmp_icons[item.kind] or ""
					item.kind = icon .. " " .. item.kind
					return item
				end,
			},
			experimental = {
				ghost_text = true,
			},
		},
	},
}
