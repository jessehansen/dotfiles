local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- dir tree
  use {
    'ms-jpq/chadtree',
    branch = 'chad',
    run = 'python3 -m chadtree deps',
    config = function() require('dotfiles.chadtree') end,
  }

  -- fuzzy finder
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
  }
  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = { 'nvim-lua/plenary.nvim' },
    after = 'telescope-fzf-native.nvim',
    config = function() require('dotfiles.telescope') end,
  }

  -- status line/tab bar
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() require('dotfiles.lualine') end,
  }

  -- git integration
  use 'tpope/vim-fugitive' -- git stuff
  use {
    'tpope/vim-rhubarb', -- github stuff
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>P", "<cmd>GBrowse!<cr>",
        { desc = "Copy github link to current file", silent = true })
      vim.api.nvim_set_keymap("n", "<leader>L", "<cmd>.GBrowse!<cr>",
        { desc = "Copy github link to current line", silent = true })
      vim.api.nvim_set_keymap("x", "<leader>L", "<cmd>GBrowse!<cr>gv\"@=v:register.'y'",
        { desc = "Copy github link to current line", silent = true })
    end,
  }
  use 'mhinz/vim-signify' -- gutter

  -- support .editorconfig
  use 'gpanders/editorconfig.nvim'

  -- theme
  use {
    'ellisonleao/gruvbox.nvim',
    config = function() require('dotfiles.colors') end,
  }

  -- close multiple buffers
  use {
    'Asheq/close-buffers.vim',
    config = function()
      vim.api.nvim_set_keymap('', '<leader>q', ':Bwipeout hidden<CR>', { desc = 'Close all hidden buffers' })
    end
  }

  -- Smart comment/uncomment
  use {
    'numToStr/Comment.nvim',
    requires = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function() require('dotfiles.comment') end
  }

  -- Split/Join lines with gS, gJ
  use 'AndrewRadev/splitjoin.vim'

  -- change surrounding quotes/brackets/tags/etc.
  use {
    'tpope/vim-surround',
    requires = { 'tpope/vim-repeat' }
  }

  -- plural-aware find and replace
  use 'tpope/vim-abolish'

  -- lsp configs
  --  coq must be configured before plugin loads
  require('dotfiles.coq')
  use { 'ms-jpq/coq_nvim', branch = 'coq' }
  use { 'ms-jpq/coq.artifacts', branch = 'artifacts', after = 'coq_nvim' }
  use {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'jayp0521/mason-null-ls.nvim',
    'neovim/nvim-lspconfig',
  }

  require('packer').use({
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  })

  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
    config = function() require('dotfiles.treesitter') end,
  }

  -- disable diagnostics during insert mode
  use {
    'https://gitlab.com/yorickpeterse/nvim-dd.git',
    config = function() require('dd').setup() end,
  }
  -- diagnostics window
  use {
    'folke/trouble.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() require('dotfiles.trouble') end
  }

  if (vim.g.jesse_lang_go) then
    use {
      'fatih/vim-go',
      run = ':GoUpdateBinaries'
    }
  end

  if (vim.g.jesse_lang_rust) then
    use 'rust-lang/rust.vim'
    use 'simrat39/rust-tools.nvim'
  end

  if (vim.g.jesse_lang_js) then
    use 'pangloss/vim-javascript'
    use 'leafgarland/typescript-vim'
    use 'mxw/vim-jsx'
    use 'ianks/vim-tsx'
    use { 'styled-components/vim-styled-components', branch = 'main' }
    use 'jparise/vim-graphql'
    use 'pantharshit00/vim-prisma'
  end

  use { vim.g.dotfiles_nvim .. "/plug" }

  pcall(require, 'dotfiles.plugs_local')

  if packer_bootstrap then
    require('packer').sync()
  end
end)
