local snippet = require("luasnip").snippet
local extras = require("luasnip.extras")

local s = require("luasnip").snippet_node
local n = require("luasnip").indent_snippet_node
local t = require("luasnip").text_node
local i = require("luasnip").insert_node
local f = require("luasnip").function_node
local c = require("luasnip").choice_node
local d = require("luasnip").dynamic_node
local r = require("luasnip").restore_node

require("luasnip").add_snippets("all", {
  snippet("now", { extras.partial(os.date, "!%Y-%m-%dT%H:%M:%SZ") } ),
})
