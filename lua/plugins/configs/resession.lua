return {
	{
		"<leader>sf",
		function()
			local resession = require("resession")
			local fzf = require("fzf-lua")
			local picker = require("plugins.utils.resession_picker")

			local function open()
				if vim.tbl_isempty(resession.list()) then
					vim.notify("No saved sessions", vim.log.levels.INFO)
					return
				end

				fzf.fzf_exec(picker.make_source(resession), {
					prompt = "Sessions  ",
					previewer = picker.make_previewer(),
					fzf_opts = {
						["--ansi"] = "",
						["--delimiter"] = "\t",
						["--with-nth"] = "2",
						["--header"] = "enter=load  ctrl-e=delete",
					},
					actions = {
						["default"] = function(selected)
							local name = selected[1]:match("^([^\t]+)")
							if name then
								resession.load(name)
							end
						end,
						["ctrl-e"] = function(selected)
							for _, item in ipairs(selected) do
								local name = item:match("^([^\t]+)")
								if name then
									resession.delete(name)
								end
							end
							vim.schedule(open)
						end,
					},
				})
			end

			open()
		end,
		desc = "Resession List",
	},
	{
		"<leader>ss",
		function()
			require("resession").save("last")
		end,
		desc = "Resession Save",
	},
}
