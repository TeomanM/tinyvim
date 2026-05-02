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

if vim.g.neovide then
	vim.api.nvim_create_autocmd({ "BufEnter", "TermOpen" }, {
		callback = function()
			local is_ergoterm = vim.bo.filetype == "ergoterm"

			vim.g.neovide_cursor_animation_length = is_ergoterm and 0 or 0.1
			vim.g.neovide_scroll_animation_length = is_ergoterm and 0 or 0.1
			vim.g.neovide_cursor_trail_size = is_ergoterm and 0 or 0.8
		end,
	})
end
