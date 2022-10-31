local dotfiles_path = vim.env.DOTFILES .. "/nvim/"
vim.g.dotfiles_nvim = dotfiles_path

local function ensure_linked()
  if vim.fn.filereadable(vim.fn.stdpath('config') .. '/lua/dotfiles/_main.lua') == 1 then
    return
  end
  local lua = vim.fn.stdpath('config') .. "/lua"
  local dotfiles = lua .. "/dotfiles"
  vim.cmd('echo "Linking ' .. dotfiles .. ' to ' .. dotfiles_path .. '"')
  if vim.fn.isdirectory(lua) == 0 then
    vim.cmd("!mkdir -p '" .. lua .. "'")
  end
  vim.cmd("!ln -s '" .. dotfiles_path .. "' '" .. dotfiles .. "'")
end

ensure_linked()

-- detect which langugages should be supported
-- - should set vim.g.jesse_lang_xxxx = true
require("dotfiles.langs")

-- variables
require("dotfiles.vars")

-- autocommands
require("dotfiles.autocmds")

-- global mappings - plugin mappings should be done in specific files
require("dotfiles.maps")

-- load plugins - also loads plugin configs
require("dotfiles.plugs")

-- set up lsp
require("dotfiles.lsp")

-- custom commands
require("dotfiles.commands")
