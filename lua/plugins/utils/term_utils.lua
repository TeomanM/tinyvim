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

function M.get_or_create_claude_term()
	local claude = M.get_claude_term()
	if claude == nil then
		local ergo = require("ergoterm")
		claude = ergo:new({
			cmd = "claude",
			name = "claude",
			layout = "right",
			auto_list = false,
			bang_target = false,
			sticky = true,
			watch_files = true,
			size = { above = "35%", below = "35%", left = "35%", right = "35%" },
		})
	end
	return claude
end

function M.get_or_create_pi_term()
	local ergo = require("ergoterm")
	local pi = vim.iter(ergo.get_all()):find(function(t)
		return t.name == "pi"
	end)
	if pi == nil then
		pi = ergo:new({
			cmd = "pi",
			name = "pi",
			layout = "right",
			auto_list = false,
			bang_target = false,
			sticky = true,
			watch_files = true,
			size = { above = "35%", below = "35%", left = "35%", right = "35%" },
		})
	end
	return pi
end

return M
