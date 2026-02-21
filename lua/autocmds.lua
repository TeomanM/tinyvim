---> NeoTree, NeoGit, Trouble and various dynamic plugins can't be saved
---> in session persistance
---> This autocmd deletes them right before saving
vim.api.nvim_create_autocmd("User", {
	pattern = "PersistedSavePre",
	callback = function()
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			local ft = vim.bo[buf].filetype
			if ft == "neo-tree" or ft == "NeogitStatus" or ft == "trouble" or ft == "ergoterm" then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end
	end,
})

---> Open QF list in trouble
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	callback = function()
		vim.cmd([[Trouble qflist open]])
	end,
})

vim.api.nvim_create_autocmd("DirChanged", {
	callback = function()
		local ergo = require("ergoterm")
		local terminals = ergo.get_all()
		for _, terminal in pairs(terminals) do
			terminal:send({ ("cd %s").format(vim.fn.getcwd()) }, { action = "start" })
			terminal:clear("start")
		end
	end,
})
