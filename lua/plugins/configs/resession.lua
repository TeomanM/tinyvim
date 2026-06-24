return {
	{
		"<leader>sf",
		function()
			local resession = require("resession")
			local fzf = require("fzf-lua")

			-- session names are "<cwd>__branch__<branch>" with "/" encoded as "|"
			local display_to_name = {}
			local entries = vim.tbl_map(function(name)
				local raw_path, branch = name:match("^(.-)__branch__(.+)$")
				local display = raw_path
					and string.format("%-40s  %s", raw_path:gsub("|", "/"), branch:gsub("|", "/"))
					or name:gsub("|", "/")
				display_to_name[display] = name
				return display
			end, resession.list())

			if vim.tbl_isempty(entries) then
				vim.notify("No saved sessions", vim.log.levels.INFO)
				return
			end

			fzf.fzf_exec(entries, {
				prompt = "Sessions  ",
				actions = {
					["default"] = function(selected)
						local name = display_to_name[selected[1]]
						if name then
							resession.load(name)
						end
					end,
					["ctrl-e"] = {
						fn = function(selected)
							for _, item in ipairs(selected) do
								local name = display_to_name[item]
								if name then
									resession.delete(name)
								end
							end
						end,
						reload = true,
					},
				},
			})
		end,
		desc = "Resession List",
	},
	{
		"<leader>ss",
		function()
			local resession = require("resession")
			resession.save("last")
		end,
		desc = "Resession Save",
	},
	{
		"<leader>sd",
		function()
			local resession = require("resession")
			for _, ses in ipairs(resession.list()) do
				resession.delete(ses)
			end
		end,
		desc = "Resession Delete All",
	},
}
