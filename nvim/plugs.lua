local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy_config = { lockfile = vim.g.dotfiles_nvim .. 'lazy-lock.json' }

local lazy_plugins = {
  { 'fladson/vim-kitty', enabled = vim.env.TERM == 'xterm-kitty' },
  -- dir tree
  {
    'ms-jpq/chadtree',
    branch = 'chad',
    build = 'python3 -m chadtree deps',
    config = function()
      require('dotfiles.chadtree')
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('dotfiles.telescope')
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('dotfiles.lualine')
    end,
  },
  'tpope/vim-fugitive',
  {
    'tpope/vim-rhubarb', -- github stuff
    config = function()
      local map = require('dotfiles.maps').map
      map('n', '<leader>P', '<cmd>GBrowse!<cr>', { desc = 'Copy github link to current file', silent = true })
      map('n', '<leader>L', '<cmd>.GBrowse!<cr>', { desc = 'Copy github link to current line', silent = true })
      map(
        'x',
        '<leader>L',
        "<cmd>GBrowse!<cr>gv\"@=v:register.'y'",
        { desc = 'Copy github link to current line', silent = true }
      )
    end,
  },
  'mhinz/vim-signify', -- gutter
  -- support .editorconfig
  'gpanders/editorconfig.nvim',
  -- theme
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require('dotfiles.colors')
    end,
  },
  -- close multiple buffers
  {
    'Asheq/close-buffers.vim',
    config = function()
      local map = require('dotfiles.maps').map
      map('', '<leader>q', ':Bwipeout hidden<CR>', { desc = 'Close all hidden buffers' })
    end,
  },
  -- Smart comment/uncomment
  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
      require('dotfiles.comment')
    end,
  },
  -- Split/Join lines with gS, gJ
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>j', '<space>s', 'gS', 'gJ' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = true,
      })
      local map = require('dotfiles.maps').map
      map('n', 'gS', ':TSJSplit<CR>', { desc = 'Split current node into multiple lines', silent = true })
      map('n', 'gJ', ':TSJJoin<CR>', { desc = 'Join current node onto single line', silent = true })
    end,
  },
  -- change surrounding quotes/brackets/tags/etc.
  {
    'tpope/vim-surround',
    dependencies = { 'tpope/vim-repeat' },
  },
  -- plural-aware find and replace
  'tpope/vim-abolish',
  -- lsp configs
  { 'ms-jpq/coq_nvim', branch = 'coq' },
  { 'ms-jpq/coq.artifacts', branch = 'artifacts', after = 'coq_nvim' },
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'jose-elias-alvarez/null-ls.nvim',
  'jayp0521/mason-null-ls.nvim',
  'neovim/nvim-lspconfig',
  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
    config = function()
      require('dotfiles.treesitter')
    end,
  },
  -- disable diagnostics during insert mode
  {
    'https://gitlab.com/yorickpeterse/nvim-dd.git',
    config = function()
      require('dd').setup()
    end,
  },
  -- diagnostics window
  {
    'folke/trouble.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('dotfiles.trouble')
    end,
  },
  {
    'fatih/vim-go',
    build = ':GoUpdateBinaries',
    enabled = vim.g.jesse_lang_go,
  },
  {
    'rust-lang/rust.vim',
    enabled = vim.g.jesse_lang_rust,
  },
  {
    'vim-test/vim-test',
    enabled = vim.g.jesse_lang_rust,
  },
  { 'pangloss/vim-javascript', enabled = vim.g.jesse_lang_js },
  { 'leafgarland/typescript-vim', enabled = vim.g.jesse_lang_js },
  { 'mxw/vim-jsx', enabled = vim.g.jesse_lang_js },
  { 'ianks/vim-tsx', enabled = vim.g.jesse_lang_js },
  { 'styled-components/vim-styled-components', branch = 'main', enabled = vim.g.jesse_lang_js },
  { 'jparise/vim-graphql', enabled = vim.g.jesse_lang_js },
  { 'pantharshit00/vim-prisma', enabled = vim.g.jesse_lang_js },
  {
    'vuki656/package-info.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function()
      require('package-info').setup()
    end,
    enabled = vim.g.jesse_lang_js,
  },
  { dir = vim.g.dotfiles_nvim .. 'plug' },
}

--  coq must be configured before plugins load
require('dotfiles.coq')

require('lazy').setup(lazy_plugins, lazy_config)
