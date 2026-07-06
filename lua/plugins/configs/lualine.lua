---@module "lualine"
return {
	options = {
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		theme = "auto",
	},
	sections = {
		lualine_c = {
			"filename",
			"hostname",
			"lsp_status",
			{
				function()
					local cwd = vim.fn.getcwd()
					if cwd == "" or cwd == "/" then
						return cwd
					end

					-- Replace home dir with ~
					local home = os.getenv("HOME") or ""
					if home ~= "" and string.find(cwd, home, 1, true) == 1 then
						cwd = "~" .. string.sub(cwd, #home + 1)
					end

					while vim.fn.strwidth(cwd) > 30 do
						-- Remove directories from the beginning until <= 20 chars
						local next = string.sub(cwd, 2)
						if next == "" then
							break
						end
						local slash = string.find(next, "/")
						if slash then
							cwd = string.sub(next, slash + 1)
						else
							cwd = next
						end
					end
					return cwd
				end,
			},
		},
	},
	extensions = {
		-- "fzf",
		"lazy",
		"man",
		"mason",
		"neo-tree",
		"trouble",
		"quickfix",
		ergoterm = {
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{
						function()
							local ergo = require("ergoterm")
							local focused_term = ergo.get_focused()
							if focused_term ~= nil then
								return focused_term.layout
							end
						end,
					},
				},
				lualine_c = { "filetype" },
				lualine_x = {
					{
						function()
							local ergo = require("ergoterm")
							local focused_term = ergo:get_focused()
							if focused_term ~= nil then
								return vim.fn.getcwd()
							end
						end,
					},
					{
						function()
							local ergo = require("ergoterm")
							local focused_term = ergo:get_focused()
							if focused_term ~= nil then
								return focused_term:get_status_icon()
							end
						end,
					},
				},
			},
			filetypes = { "ergoterm" },
		},
	},
	theme = "auto",
}
