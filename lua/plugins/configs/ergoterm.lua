return {
	{
		"<M-h>",
		function()
			local ergo = require("ergoterm")
			local current_tabpage = vim.api.nvim_get_current_tabpage()

			local all_terms = ergo.get_all()
			local horizontal
			for _, term in ipairs(all_terms) do
				if term.meta.tabpage == current_tabpage and term.layout == "below" then
					horizontal = term
					break
				end
			end

			if horizontal == nil then
				horizontal = ergo:new({ layout = "below", name = "Horizontal", meta = { tabpage = current_tabpage } })
			end
			horizontal:toggle()
		end,
		desc = "Toggle Horizontal Terminal",
		mode = { "n", "t" },
	},
	{
		"<M-v>",
		function()
			local ergo = require("ergoterm")
			local current_tabpage = vim.api.nvim_get_current_tabpage()

			local all_terms = ergo.get_all()
			local vertical
			for _, term in ipairs(all_terms) do
				if term.meta.tabpage == current_tabpage and term.layout == "right" then
					vertical = term
					break
				end
			end

			if vertical == nil then
				vertical = ergo:new({ layout = "right", name = "Vertical", meta = { tabpage = current_tabpage } })
			end
			vertical:toggle()
		end,
		desc = "Toggle Vertical Terminal",
		mode = { "n", "t" },
	},
	{
		"<M-i>",
		function()
			local ergo = require("ergoterm")
			local current_tabpage = vim.api.nvim_get_current_tabpage()

			local all_terms = ergo.get_all()
			local floating
			for _, term in ipairs(all_terms) do
				if term.meta.tabpage == current_tabpage and term.layout == "float" then
					floating = term
					break
				end
			end

			if floating == nil then
				floating = ergo:new({
					layout = "float",
					name = "Floating",
					float_opts = { title = "Floating Term" },
					meta = { tabpage = current_tabpage },
				})
			end
			floating:toggle()
		end,
		desc = "Toggle Floating Terminal",
		mode = { "n", "t" },
	},
}
