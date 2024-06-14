local utils = {}

function utils.without_duplicates(a)
	local r = {}
	local inserted = {}

	for _, v in ipairs(a) do
		if not inserted[v] then
			table.insert(r, v)
			inserted[v] = true
		end
	end

	return r
end

return utils
