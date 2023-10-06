local p = require('gruvbox').palette
require('gruvbox').setup({
  overrides = {
    Operator = { italic = false, bold = true },
    LspReferenceRead = { fg = p.faded_aqua, italic = false, bold = true },
    LspReferenceWrite = { fg = p.faded_orange, italic = false, bold = true },
    LspReferenceText = { italic = false, bold = true },
    SpellBad = { sp = p.bright_orange, undercurl = 1 },
  },
})
vim.o.background = 'dark'
vim.cmd('colorscheme gruvbox')
