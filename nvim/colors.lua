require("gruvbox").setup({
  overrides = {
    Operator = { italic = false, bold = true }
  }
})
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")
