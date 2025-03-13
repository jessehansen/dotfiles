vim.g.chadtree_settings = {
  options = {
    follow = false,
    session = false,
  },
  theme = {
    text_colour_set = 'nerdtree_syntax_dark',
  },
  view = {
    sort_by = { 'is_folder', 'file_name', 'ext' },
  },
  keymap = {
    v_split = { 'w', '<C-V>' },
    h_split = { 'W', '<C-X>' },
    change_dir = {},
    change_focus = {},
    change_focus_up = { '<C-K>' },
  },
}
local map = require('dotfiles.maps').map

map('n', '<leader>d', ':CHADopen<CR>', { silent = true, desc = 'Toggle open directory tree' })
map('n', '<leader>e', function()
  CHAD.Open({ '--always-focus' })
  CHAD.Toggle_follow(false)
  -- At some point, CHAD started waiting to load the tree after open was called,
  -- so my previous hack to toggle follow/unfollow stopped working.
  -- Instead, Jump_to_current is called after a delay to give the tree time to load
  -- In addition, it looks like following must currently be on for jump to work
  vim.defer_fn(function()
    CHAD.Jump_to_current(true)
    CHAD.Toggle_follow(false)
  end, 100)
end, { desc = 'Find current buffer in directory tree' })

vim.api.nvim_create_augroup('dotfiles_chadtree', { clear = true })

-- I don't know why this doesn't work for FileType events (it runs without "sticking"), but BufEnter works
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  command = "if &filetype=='CHADTree' | set nospell | endif",
  group = 'dotfiles_chadtree',
})
