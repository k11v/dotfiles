local mod = "internal.lsp_progress"

local group = vim.api.nvim_create_augroup(mod, {})

local lsp_progress
do
	local progress_from_key = {}

	lsp_progress = function(args)
		local buffer_id = args.buf
		local client_id = args.data.client_id
		local token = args.data.params.token
		local value = args.data.params.value

		-- Get client name.
		local client = vim.lsp.get_client_by_id(client_id)
		if client == nil then
			return
		end
		local client_name = client.name

		-- Get progress key.
		local progress_key = string.format("%s:%s:%s", buffer_id, client_id, token)
		local progress_value = progress_from_key[progress_key]

		-- Get and set notification parameters.
		if value.kind == "begin" then
			if progress_value ~= nil then
				return
			end
			progress_value = {}
			progress_value.name = client.name or ""
			progress_value.title = value.title or ""
			progress_value.message = value.message or ""
			progress_value.percentage = 0
			progress_from_key[progress_key] = progress_value
		elseif value.kind == "report" then
			if progress_value == nil then
				return
			end
			progress_value.message = value.message or ""
			progress_value.percentage = value.percentage or progress_value.percentage
			progress_from_key[progress_key] = progress_value
		elseif value.kind == "end" then
			if progress_value == nil then
				return
			end
			progress_value.message = value.message or ""
			progress_value.percentage = 100
			progress_from_key[progress_key] = progress_value
		else
			return
		end

		-- Get notification.
		local notification = string.format(
			"%s: %s%s%s%s(%s%%)",
			progress_value.name,
			progress_value.title,
			progress_value.title == "" and "" or " ",
			progress_value.message,
			progress_value.message == "" and "" or " ",
			progress_value.percentage
		)

		-- Send notification.
		vim.notify(notification)
	end
end

vim.api.nvim_create_autocmd("LspProgress", { group = group, callback = lsp_progress })
