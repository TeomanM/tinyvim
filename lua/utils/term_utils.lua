local M = {}

function M.toggle_tab_term(name, opts)
	local ergo = require("ergoterm")
	local tabpage = vim.api.nvim_get_current_tabpage()
	local term = vim.iter(ergo.get_all()):find(function(t)
		return t.meta.tabpage == tabpage and t.name == name
	end)
	if term == nil then
		term = ergo:new(vim.tbl_extend("keep", { name = name, watch_files = true, meta = { tabpage = tabpage } }, opts))
	end
	term:toggle()
end

function M.get_claude_term()
	local ergo = require("ergoterm")
	return vim.iter(ergo.get_all()):find(function(t)
		return t.name == "claude"
	end)
end

return M
