local util = {}

for k, v in pairs(require("internal.util.lazyfile")) do
	util[k] = v
end

return util
