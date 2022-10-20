local p = require("gruvbox.palette")
require("gruvbox").setup({
  overrides = {
    Operator = { italic = false, bold = true },
    LspReferenceRead = { bg = p.dark1, fg = p.faded_aqua, italic = false, bold = false },
    LspReferenceWrite = { bg = p.dark1, fg = p.faded_orange, italic = false, bold = true },
    LspReferenceText = { bg = p.dark1, italic = false, bold = true },
  }
})
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")
