local utils = {}

for k, v in pairs(require("internal.utils.fun")) do
	utils[k] = v
end

for k, v in pairs(require("internal.utils.lazyfile")) do
	utils[k] = v
end

return utils
