vim.api.nvim_create_augroup('dotfiles', { clear = true })
-- always open help in right vertical pane
vim.api.nvim_create_autocmd('Filetype', { pattern = 'help', command = 'wincmd L', group = 'dotfiles' })
-- always open copilot suggestions in right vertical pane
vim.api.nvim_create_autocmd('Filetype', { pattern = 'copilot.*', command = 'wincmd L', group = 'dotfiles' })

-- :bp and :bn should skip quickfix buffers
vim.api.nvim_create_autocmd('FileType', { pattern = 'qf', command = 'set nobuflisted', group = 'dotfiles' })

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  group = 'dotfiles',
  callback = function()
    vim.highlight.on_yank({ on_visual = true, timeout = 500 })
  end,
})

-- set some kitty-specific variables
vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  group = vim.api.nvim_create_augroup('KittySetVarVimEnter', { clear = true }),
  callback = function()
    io.stdout:write('\x1b]1337;SetUserVar=in_editor=MQo\007')
  end,
})

vim.api.nvim_create_autocmd({ 'VimLeave' }, {
  group = vim.api.nvim_create_augroup('KittyUnsetVarVimLeave', { clear = true }),
  callback = function()
    io.stdout:write('\x1b]1337;SetUserVar=in_editor\007')
  end,
})
