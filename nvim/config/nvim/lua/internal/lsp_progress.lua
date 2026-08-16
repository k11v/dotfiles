local mod = "internal.lsp_progress"

local lsp_progress_kind_begin = "begin"
local lsp_progress_kind_report = "report"
local lsp_progress_kind_end = "end"

local progress_kind_progress = "progress"

local progress_status_success = "success"
local progress_status_running = "running"
local progress_status_failed = "failed"
local progress_status_cancel = "cancel"

local group = vim.api.nvim_create_augroup(mod, {})

local lsp_progress_callback
do
	local progress_from_key = {}

	lsp_progress_callback = function(args)
		local lsp_client_id = args.data.client_id

		local lsp_client_token = args.data.params.token

		---@type { kind?: string, title?: string, message?: string, percentage?: integer }
		local lsp_progress = args.data.params.value

		local lsp_client = vim.lsp.get_client_by_id(lsp_client_id)
		if lsp_client == nil then
			return
		end

		local progress_key = string.format("%s:%s", lsp_client_id, lsp_client_token)

		---@type { id?: string|integer, kind?: string, percent?: integer, source?: string, status?: string, title?: string }
		local progress = vim.deepcopy(progress_from_key[progress_key]) or {}

		if lsp_progress.kind == lsp_progress_kind_begin then
			progress.kind = progress_kind_progress
			progress.percent = 0
			progress.source = mod
			progress.status = progress_status_running
			progress.title = (lsp_client.name and lsp_client.name or "client " .. tostring(lsp_client.id))
				.. (lsp_progress.title and ": " .. lsp_progress.title or "")
		elseif lsp_progress.kind == lsp_progress_kind_report then
			progress.percent = lsp_progress.percentage
		elseif lsp_progress.kind == lsp_progress_kind_end then
			progress.percent = 100
			progress.status = progress_status_success
		else
			return
		end

		local message = lsp_progress.message or ""

		progress.id = vim.api.nvim_echo({ { message } }, true, progress)
		progress_from_key[progress_key] = progress
	end
end

vim.api.nvim_create_autocmd("LspProgress", { group = group, callback = lsp_progress_callback })
