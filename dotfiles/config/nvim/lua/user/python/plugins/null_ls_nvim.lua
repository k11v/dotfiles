local opts = function(_, opts)
	local ruff_format = {
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
	}

	vim.list_extend(opts.sources, {
		ruff_format,
	})
end

local plugin = {
	"none-ls.nvim",
	opts = opts,
}

return { plugin }
