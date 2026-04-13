local function get_session_name()
	local name = vim.fn.getcwd()
	local branch = vim.trim(vim.fn.system("git branch --show-current"))
	if vim.v.shell_error == 0 then
		return name .. "__branch__" .. branch
	else
		return name
	end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		local resession = require("resession")
		resession.save(get_session_name())
	end,
})

---> Open QF list in trouble
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	callback = function()
		vim.cmd([[Trouble qflist open]])
	end,
})

vim.api.nvim_create_autocmd("DirChanged", {
	callback = function(_)
		local ergo = require("ergoterm")
		local all_terminals = ergo.get_all()
		for _, term in ipairs(all_terminals) do
			if term.meta.tabpage == vim.api.nvim_get_current_tabpage() then
				term:send({ ("cd %s").format(vim.fn.getcwd()) }, { action = "start" })
				term:clear("start")
			end
		end
	end,
})

-- vim.api.nvim_create_autocmd("LspProgress", {
-- 	callback = function(ev)
-- 		local value = ev.data.params.value or {}
-- 		local msg = value.message or "done"
-- 
-- 		-- rust analyszer in particular has really long LSP messages so truncate them
-- 		if #msg > 40 then
-- 			msg = msg:sub(1, 37) .. "..."
-- 		end
-- 		-- :h LspProgress
-- 		vim.api.nvim_echo({ { msg } }, false, {
-- 			id = "lsp",
-- 			kind = "progress",
-- 			title = value.title,
-- 			status = value.kind ~= "end" and "running" or "success",
-- 			percent = value.percentage,
-- 		})
-- 	end,
-- })
