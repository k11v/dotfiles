local luasnip = require("luasnip")
local snippet = luasnip.snippet
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node

return {
	snippet("shrugs", { text_node([[¯\_(ツ)_/¯]] .. "\n") }),
	snippet("cowsay", {
		text_node([[            ^__^  /]] .. " "),
		insert_node(1, "Moo?"),
		text_node(
			"\n"
				.. [[    _______/(oo) /]]
				.. "\n"
				.. [[/\/)       /(__)]]
				.. "\n"
				.. [[   | w----||]]
				.. "\n"
				.. [[   ||     ||]]
				.. "\n"
		),
	}),
}
