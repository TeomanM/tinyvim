return {
	{
		"<M-h>",
		function()
			local ergo = require("ergoterm")
			local current_tabpage = vim.api.nvim_get_current_tabpage()

			local all_terms = ergo.get_all()
			local horizontal
			for _, term in ipairs(all_terms) do
				if term.meta.tabpage == current_tabpage and term.name == "Horizontal" then
					horizontal = term
					break
				end
			end

			if horizontal == nil then
				horizontal = ergo:new({ layout = "below", name = "Horizontal", watch_files = true, meta = { tabpage = current_tabpage } })
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
				if term.meta.tabpage == current_tabpage and term.name == "Vertical" then
					vertical = term
					break
				end
			end

			if vertical == nil then
				vertical = ergo:new({ layout = "right", name = "Vertical", watch_files = true, meta = { tabpage = current_tabpage } })
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
				if term.meta.tabpage == current_tabpage and term.name == "Floating" then
					floating = term
					break
				end
			end

			if floating == nil then
				floating = ergo:new({
					layout = "float",
					name = "Floating",
					watch_files = true,
					float_opts = { title = "Floating Term" },
					meta = { tabpage = current_tabpage },
				})
			end
			floating:toggle()
		end,
		desc = "Toggle Floating Terminal",
		mode = { "n", "t" },
	},
	{
		"<M-a>",
		function()
			local ergo = require("ergoterm")
			local all_terms = ergo.get_all()
			local claude
			for _, term in ipairs(all_terms) do
				if term.name == "claude" then
					claude = term
					break
				end
			end

			if claude == nil then
				claude = ergo:new({
					cmd = "claude",
					name = "claude",
					layout = "right",
					auto_list = false,
					bang_target = false,
					sticky = true,
					watch_files = true,
					size = {
						above = "35%",
						below = "35%",
						left = "35%",
						right = "35%",
					},
				})
			end
			claude:toggle()
		end,
		desc = "Toggle Claude Code",
		mode = { "n", "t" },
	},
}
