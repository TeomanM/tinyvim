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
	filesystem = {
		filtered_items = {
			show_hidden_count = false,
		},
	},
	default_component_configs = {
		diagnostics = {
			symbols = {
				hint = "",
				info = "",
				warn = "",
				error = "",
			},
		},
		git_status = {
			symbols = {
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
}
