return {
	{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "FzfLua find buffers" },
	{ "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "FzfLua help page" },
	{ "<leader>ma", "<cmd>FzfLua marks<cr>", desc = "FzfLua find marks" },
	{ "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "FzfLua find oldfiles" },
	{ "<leader>fz", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "FzfLua find in current buffer" },
	{ "<leader>cm", "<cmd>FzfLua git_commits<cr>", desc = "FzfLua git commits" },
	{ "<leader>gt", "<cmd>FzfLua git_status<cr>", desc = "FzfLua git status" },
	{ "<leader>fw", "<cmd>FzfLua live_grep<cr>", desc = "FzfLua live grep" },
	{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "FzfLua find files" },
	{ "<leader>fa", "<cmd>FzfLua files hidden=true<cr>", desc = "FzfLua find all files" },
	{ "<leader>mp", "<cmd>FzfLua manpages<cr>", desc = "FzfLua Search Manpages" },
	{ "<leader>ob", "<cmd>FzfLua buffers<cr>", desc = "FzfLua Buffers" },

	{
		"<leader>fs",
		function()
			require("fzf-lua").files()
			FzfLua.files({
				cwd = "/usr/share/doc/",
			})
		end,
		desc = "FzfLua Search Docs",
	},
}
