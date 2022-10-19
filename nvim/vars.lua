-- contains variables and default config

-- use gui colors in term
vim.opt.termguicolors = true

-- better update time for async
vim.opt.updatetime = 600

-- show hidden chars
vim.opt.list = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.listchars = { tab = '▸ ', eol = '¬', space = '·' }

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
vim.cmd [[let &t_ut='']]

-- use ripgrep for fzf and Ack if avialable
if vim.fn.executable('rg') then
  vim.opt.grepprg = "rg --vimgrep --smart-case --follow"
end

-- always show tab line so that buffers are always available
