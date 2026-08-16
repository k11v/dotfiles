local mod = "internal.lsp_gri"

local function is_mock(filename)
	local basename = vim.fn.fnamemodify(filename, ":t")
	if basename:match("^mock_.*%.go$") or basename:match("_mock%.go$") then
		return true
	end
	local dir = vim.fn.fnamemodify(filename, ":h")
	if dir:match("/mocks?$") or dir:match("/mocks?/") then
		return true
	end
	return false
end

vim.keymap.set("n", "gri", function()
	vim.lsp.buf.implementation({
		on_list = function(list)
			list.items = vim.tbl_filter(function(item)
				return not is_mock(item.filename)
			end, list.items)

			vim.fn.setqflist({}, " ", { title = list.title, items = list.items })
			if #list.items == 1 then
				local bufnr = vim.api.nvim_get_current_buf()
				local win = vim.api.nvim_get_current_win()
				local from = vim.fn.getpos(".")
				from[1] = bufnr
				local tagname = vim.fn.expand("<cword>")
				local tagstack = { { tagname = tagname, from = from } }
				vim.fn.settagstack(vim.fn.win_getid(win), { items = tagstack }, "t")
				vim.cmd("cfirst")
			else
				vim.cmd("botright copen")
			end
		end,
	})
end, { desc = "Go to implementation (without mocks)" })

vim.keymap.set("n", "grI", function()
	vim.lsp.buf.implementation()
end, { desc = "Go to implementation (all)" })
