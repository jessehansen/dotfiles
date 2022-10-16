vim.g.chadtree_settings = {
	options = {
		follow = false,
		session = false,
	},
	theme = {
		text_colour_set = "nerdtree_syntax_dark",
	},
	view = {
		sort_by = { "is_folder", "file_name", "ext" },
	},
	keymap = {
		v_split = { "w", "<C-V>" },
		h_split = { "W", "<C-X>" },
		change_dir = {},
		change_focus = {},
		change_focus_up = {},
	}
}

vim.keymap.set('n', '<leader>d', ':CHADopen<CR>', {desc="Toggle open directory tree"})
vim.keymap.set('n', '<leader>e', function()
  CHAD.Toggle_follow(false)
  CHAD.Open({'--always-focus'})
  CHAD.Toggle_follow(false)
end, {desc="Find current buffer in directory tree"})
