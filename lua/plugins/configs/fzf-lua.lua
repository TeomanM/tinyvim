return {
	{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find buffers" },
	{ "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Help page" },
	{ "<leader>ma", "<cmd>FzfLua marks<cr>", desc = "Find marks" },
	{ "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Find oldfiles" },
	{ "<leader>fz", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "Find in current buffer" },
	{ "<leader>cm", "<cmd>FzfLua git_commits<cr>", desc = "Git commits" },
	{ "<leader>gt", "<cmd>FzfLua git_status<cr>", desc = "Git status" },
	{ "<leader>fw", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
	{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
	{ "<leader>fa", "<cmd>FzfLua files hidden=true<cr>", desc = "Find all files" },
	{ "<leader>mp", "<cmd>FzfLua manpages<cr>", desc = "Search Manpages" },
	{ "<leader>ob", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
	{ "<leader>th", "<cmd>FzfLua colorschemes<cr>", desc = "Colorschemes" },

	{
		"<leader>fs",
		function()
			require("fzf-lua").files()
			FzfLua.files({
				cwd = "/usr/share/doc/",
			})
		end,
		desc = "Search Docs",
	},
}
