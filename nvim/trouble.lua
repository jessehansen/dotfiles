require("trouble").setup {
  position = "bottom",
  mode = "document_diagnostics",
}

-- key bindings
vim.keymap.set("n", "<leader>t", "<cmd>TroubleToggle<cr>",
  { desc="Toggle Trouble Diagnostics Window", silent=true, noremap=true }
)
vim.keymap.set("n", "<leader>x", function()
    vim.cmd('ccl')
    vim.cmd('lcl')
    vim.cmd('TroubleClose')
  end,
  { desc="Close quickfix, location, and trouble windows" }
)
