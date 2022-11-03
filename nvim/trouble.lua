require("trouble").setup {
  position = "bottom",
  mode = "document_diagnostics",
}

local map = require('dotfiles.maps').map

-- key bindings
map("n", "<leader>t", "<cmd>TroubleToggle<cr>",
  { desc = "Toggle Trouble Diagnostics Window", silent = true, noremap = true }
)
map("n", "<leader>x", ":ccl <bar> lcl <bar> TroubleClose<CR>",
  { desc = "Close quickfix, location, and trouble windows" }
)
