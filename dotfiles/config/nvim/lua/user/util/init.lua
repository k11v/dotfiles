local util = {}

for k, v in pairs(require("user.util.lazyfile")) do
	util[k] = v
end

return util
