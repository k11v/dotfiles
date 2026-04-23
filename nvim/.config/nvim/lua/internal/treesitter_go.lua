local ts = require("internal.treesitter")

ts.config("go",     { filetypes = { "go" } })
ts.config("gomod",  { filetypes = { "gomod" } })
ts.config("gosum",  { filetypes = { "gosum" } })
ts.config("gotmpl", { filetypes = { "gotmpl" } })
ts.config("gowork", { filetypes = { "gowork" } })

ts.enable({ "go", "gomod", "gosum", "gotmpl", "gowork" })
