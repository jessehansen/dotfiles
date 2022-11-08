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
local map = require('dotfiles.maps').map

map('n', '<leader>d', ':CHADopen<CR>', { silent = true, desc = "Toggle open directory tree" })
map('n', '<leader>e', function()
  CHAD.Toggle_follow(false)
  CHAD.Open({ '--always-focus' })
  CHAD.Toggle_follow(false)
end, { desc = "Find current buffer in directory tree" })

vim.api.nvim_create_augroup("dotfiles_chadtree", { clear = true })
-- I don't know why this doesn't work for FileType events (it runs without "sticking"), but BufEnter works
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  command = "if &filetype=='CHADTree' | set nospell | endif",
  group = "dotfiles_chadtree",
})
