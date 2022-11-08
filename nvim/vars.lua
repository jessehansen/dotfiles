-- contains variables and default config

-- use gui colors in term
vim.opt.termguicolors = true

-- better update time for async
vim.opt.updatetime = 600

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.spell = true
vim.opt.spelloptions = { 'camel' }

-- note the bullet (space replacement) is U+2219 "∙", not U+00B7 "·"
-- this prevents "l l" from being rendered as a ligament in some terminal emulators with some fonts
-- see https://github.com/neovim/neovim/issues/20839
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', eol = '¬', space = '∙' }

-- work with hidden buffers
vim.opt.hidden = true
-- don't ever ever flash my screen
vim.opt.visualbell = false
-- always show line numbers
vim.opt.number = true
-- lualine covers this
vim.opt.showmode = false
-- live substitution
vim.opt.inccommand = 'nosplit'

-- Mouse support
vim.opt.mouse = 'a'

-- disable background color erase (helps kitty and tmux)
vim.cmd([[let &t_ut='']])

-- use ripgrep for fzf and Ack if available
if vim.fn.executable('rg') then
  vim.opt.grepprg = 'rg --vimgrep --smart-case --follow'
end

-- always show tab line so that buffers are always available
