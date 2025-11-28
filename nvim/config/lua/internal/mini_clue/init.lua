local M = {}

M.setup = function(opts)
	local miniclue_clue_arms = (opts or {}).miniclue_clue_arms or {}
	local miniclue_trigger_arms = (opts or {}).miniclue_trigger_arms or {}

	do
		require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.clue" })

		require("mini.clue").setup({
			clues = nil, -- dynamic
			triggers = nil, -- dynamic
			window = { delay = 0 },
		})
	end

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.miniclue", {}),
		callback = function(args)
			local clues = {}

			for _, arm in ipairs(require("internal.app").matches(args.buf, miniclue_clue_arms)) do
				local mode = arm.key[1]
				local lhs = arm.key[2]
				local rhs = arm.value[1]
				local desc = arm.value[2]

				table.insert(clues, { mode = mode, keys = lhs, desc = desc })
			end

			local triggers = {}

			for _, arm in ipairs(require("internal.app").matches(args.buf, miniclue_trigger_arms)) do
				local mode = arm.key[1]
				local lhs = arm.key[2]
				local rhs = arm.value[1]
				local desc = arm.value[2]

				table.insert(triggers, { mode = mode, keys = lhs })
			end

			vim.b[args.buf].miniclue_config = {
				clues = clues,
				triggers = triggers,
				window = nil, -- static
			}

			require("mini.clue").ensure_buf_triggers(args.buf)
		end,
	})
end

return M
