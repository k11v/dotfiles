local M = {}

M.setup = function(opts)
	local treesitter_arms = (opts or {}).treesitter_arms or {}

	do
		local parsers = {}

		for _, arm in ipairs(treesitter_arms) do
			local arm_parsers

			if type(arm.value) == "table" then
				arm_parsers = arm.value
			elseif type(arm.value) == "string" then
				arm_parsers = { arm.value }
			elseif type(arm.value) == "boolean" then
				if arm.value then
					arm_parsers = {}
					for _, filetype in ipairs(arm.pattern.ft or {}) do
						table.insert(arm_parsers, vim.treesitter.language.get_lang(filetype))
					end
				end
			end

			for _, arm_parser in ipairs(arm_parsers) do
				table.insert(parsers, arm_parser)
			end
		end

		if #parsers > 0 then
			require("nvim-treesitter").install(parsers):wait(10 * 60 * 1000)
		end
	end
end

return M
