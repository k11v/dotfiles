local config_signs = function()
	vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticInfo" })
	vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticInfo" })
	vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })
	vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DiagnosticInfo" })
	vim.fn.sign_define("DapStopped", { text = "󰁕", texthl = "DiagnosticWarn" })
end

-- TODO: Consider `<leader>dB` for "toggle breakpoint with condition"
local config_keymaps = function()
	vim.keymap.set({ "n" }, "<leader>dr", function()
		require("dap").continue()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>dR", function()
		require("dap").restart()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>dq", function()
		require("dap").terminate()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>db", function()
		require("dap").toggle_breakpoint()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>de", function()
		require("dap").set_exception_breakpoints("default")
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>dc", function()
		require("dap").clear_breakpoints()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>dj", function()
		require("dap").step_into()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>dk", function()
		require("dap").step_out()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>dl", function()
		require("dap").step_over()
	end, { silent = true })
end

local config = function()
	config_signs()
	config_keymaps()
end

local plugin = {
	url = "https://github.com/mfussenegger/nvim-dap",
	config = config,
}

return { plugin }
