local luasnip = require("luasnip")
local snippet = luasnip.snippet
local text_node = luasnip.text_node

return {
	snippet("shrugs", { text_node([[¯\_(ツ)_/¯]]) }),
	snippet("shrugs2", { text_node([[¯\_( ͡° ͜ʖ ͡°)_/¯]]) }),
}
