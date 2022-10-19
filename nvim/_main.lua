vim.g.dotfiles_nvim = vim.env.DOTFILES .. "/nvim/"

local function SourceMy(relativePath)
  local fullPath = vim.g.dotfiles_nvim .. relativePath
  if vim.fn.filereadable(fullPath) == 1 then
    vim.cmd("source " .. fullPath)
  end
end

vim.api.nvim_create_user_command("SourceMy", function(opts)
  SourceMy(opts.args)
end, { nargs = 1, desc = "Source from my nvim dotfiles" })

-- detect which langugages should be supported
-- - should set vim.g.jesse_lang_xxxx = true
SourceMy("langs.lua")

-- variables
SourceMy("vars.lua")

-- autocommands
SourceMy("autocmds.lua")

-- global mappings - plugin mappings should be done in specific files
SourceMy("maps.lua")

-- load plugins - also loads plugin configs
SourceMy("plugs.lua")

-- set up lsp
SourceMy("lsp.lua")

SourceMy("commands.lua")
