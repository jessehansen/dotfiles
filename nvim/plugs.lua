local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local map = require('dotfiles.maps').map
      require('nvim-tree').setup({
        view = {
          width = {
            min = 30,
            max = 60,
          },
        },
        actions = {
          open_file = {
            window_picker = {
              enable = false,
            },
          },
        },
        git = {
          timeout = 4000,
        },
        filters = {
          git_ignored = false,
          custom = function(path)
            -- hide .null-ls files
            local name = vim.fs.basename(path)
            if string.find(name, '.null-ls') == 0 then
              return true
            else
              return false
            end
          end,
        },
      })

      local api = require('nvim-tree.api')
      map('n', '<leader>d', function()
        api.tree.toggle()
      end, { desc = 'Toggle open directory tree', silent = true })
      map('n', '<leader>e', function()
        api.tree.open({ find_file = true })
      end, { desc = 'Find current buffer in directory tree', silent = true })
    end,
  },
  -- {
  --   'ms-jpq/chadtree',
  --   branch = 'chad',
  --   build = 'python3 -m chadtree deps',
  --   config = function()
  --     require('dotfiles.chadtree')
  --   end,
  -- },
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
    lazy = false,
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
  {
    'github/copilot.vim',
    config = function()
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)')
      vim.keymap.set('i', '<M-q>', '<ESC>:Copilot panel<CR>')
      vim.keymap.set('n', '<M-q>', ':Copilot panel<CR>')

      vim.g.copilot_no_tab_map = true
      vim.g.copilot_hide_during_completion = false
    end,
  },
  -- lsp configs
  { 'ms-jpq/coq_nvim', branch = 'coq', build = ':COQdeps' },
  { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  { 'nvimtools/none-ls.nvim', dependencies = { 'nvimtools/none-ls-extras.nvim' } },
  'jay-babu/mason-null-ls.nvim',
  'neovim/nvim-lspconfig',
  {
    'luckasRanarison/clear-action.nvim',
    config = function()
      local ca = require('clear-action')
      local map_many = require('dotfiles.maps').map_many
      ca.setup({ signs = { enable = false } })

      map_many('', { '<space>ca', '<M-a>' }, function()
        ca.code_action({
          filter = function(action)
            -- filter out undesired actions
            -- print(vim.inspect(action))

            -- This never does what I want
            if action.kind == 'refactor.move' then
              return false
            end
            -- This action is useless and I do it accidentally too much
            if action.title == 'Convert named export to default export' then
              return false
            end
            -- usually duplicated with eslint actions in my setup
            if vim.startswith(action.title, 'Disable stylelint rule') then
              return false
            end
            return true
          end,
        })
      end, { desc = 'Show code actions' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
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
