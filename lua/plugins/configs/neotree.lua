---@type neotree.Config
return {
	enable_cursor_hijack = true,
	open_files_do_not_replace_types = {
		"terminal",
		"ergoterm",
		"Trouble",
		"qf",
		"edgy",
	},
	open_files_in_last_window = false,
	clipboard = {
		sync = "universal",
	},
	---@type neotree.Config.Filesystem
	filesystem = {
		filtered_items = {
			show_hidden_count = false,
		},
	},
	---@type neotree.Config.ComponentDefaults
	default_component_configs = {
		git_status = {
			symbols = {
				unstaged = "",
				untracked = "",
			},
		},
		icon = {
			default = "󰈚",
			folder_closed = "",
			folder_empty = "",
			folder_empty_open = "󰞹",
			folder_open = "",
			use_filtered_colors = true,
		},
		indent = {
			with_expanders = true,
			expander_collapsed = "",
			expander_expanded = "",
		},
		name = {
			highlight_opened_files = true,
		},
		symlink_target = {
			enabled = true,
		},
	},
	renderers = {
		directory = {
			{ "indent" },
			{ "icon" },
			{ "current_filter" },
			{
				"container",
				content = {
					{ "name", zindex = 10 },
					{
						"symlink_target",
						zindex = 10,
						highlight = "NeoTreeSymbolicLinkTarget",
					},
					{ "clipboard", zindex = 10 },
					{ "diagnostics", errors_only = false, zindex = 20, align = "right", hide_when_expanded = true },
					{ "git_status", zindex = 10, align = "right", hide_when_expanded = true },
					{ "file_size", zindex = 10, align = "right" },
					{ "type", zindex = 10, align = "right" },
					{ "last_modified", zindex = 10, align = "right" },
					{ "created", zindex = 10, align = "right" },
				},
			},
		},
	},
}
