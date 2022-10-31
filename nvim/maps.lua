-- contains custom mappings
-- additional mappings present in plugin configs and in plug/ftplugin for specific file types
-- use telescope's builtin.keymaps function to see mappings

vim.g.mapleader = ","

local K = vim.keymap.set

-- window navigation
K("", "<C-h>", "<C-w>h", { silent = true, desc = "Move cursor one window to the left" })
K("", "<C-j>", "<C-w>j", { silent = true, desc = "Move cursor one window down" })
K("", "<C-k>", "<C-w>k", { silent = true, desc = "Move cursor one window up" })
K("", "<C-l>", "<C-w>l", { silent = true, desc = "Move cursor one window to the right" })

-- window sizing
K("", "<C-w>.", "<C-w>>", { silent = true, desc = "Grow current window" })
K("", "<C-w>,", "<C-w><", { silent = true, desc = "Shrink current window" })

-- window closing
K("n", "<leader>x", ":ccl <bar> lcl<CR>", { silent = true, desc = "Close quicklist & loclist windows" })

--quickfix navigation
K("n", "<leader>>", "<cmd>cn<CR>", { silent = true, desc = "Go to next quicklist item" })
K("n", "<leader>.", "<cmd>cn<CR>", { silent = true, desc = "Go to next quicklist item" })
K("n", "]c", "<cmd>cn<CR>", { silent = true, desc = "Go to next quicklist item" })
K("n", "<leader><", "<cmd>cp<CR>", { silent = true, desc = "Go to previous quicklist item" })
K("n", "<leader>,", "<cmd>cp<CR>", { silent = true, desc = "Go to previous quicklist item" })
K("n", "[c", "<cmd>cp<CR>", { silent = true, desc = "Go to previous quicklist item" })

K("c", "%%", "<C-R>=fnameescape(expand('%:h'))<CR>/", { desc = "Insert current file directory" })

K("", "<leader>/", ":noh<CR>", { silent = true, desc = "Clear search highlight" })

-- clipboard mappings
K("x", "<leader>y", '"+y', { silent = true, noremap = true, desc = "Copy to system keyboard" })
K("x", "<C-y>", '"+y', { silent = true, noremap = true, desc = "Copy to system keyboard" })
K("n", "<C-y>", '"+yy', { silent = true, noremap = true, desc = "Copy current line to system keyboard" })
K("x", "p", [[pgv"@=v:register.'y'<cr>]],
  { silent = true, noremap = true, desc = "Paste without stomping register" })

-- buffer mappings
K("n", "<Leader>h", ":bp<cr>", { silent = true, noremap = true, desc = "Next Buffer" })
K("n", "<Leader>l", ":bn<cr>", { silent = true, noremap = true, desc = "Previous Buffer" })

K("n", "<Leader>w", ":b#<bar>bd#<CR>",
  { silent = true, noremap = true, desc = "Close current buffer and switch to another" })

K("n", "<leader>a", "ggVG", { noremap = true, desc = "Select all in current buffer" })
K("n", "zz", "G", { noremap = true, desc = "Go to end of current buffer" })

K("n", "<leader>p", function()
  local value = vim.fn.expand("%")
  vim.fn.setreg("+", value)
  vim.cmd('echo "Copied \\"' .. value .. '\\" to system clipboard"')
end, { desc = "Copy current file name to system clipboard" })

-- visual mode indentation should not clear selection
K("v", "<Tab>", ">gv", { silent = true, desc = "Increase indent" })
K("v", "<S-Tab>", "<gv", { silent = true, desc = "Decrease indent" })
K("v", ">", ">gv", { silent = true, noremap = true, desc = "Increase indent" })
K("v", "<", "<gv", { silent = true, noremap = true, desc = "Decrease indent" })

-- yanking in visual mode should not clear selection

-- ctrl-s saves in insert mode
K("i", "<C-s>", "<Esc>:w<CR>a", { noremap = true, desc = "Save current buffer" })

-- terminal mode mappings
K("t", "<Esc>", "<C-\\><C-n>", { noremap = true, desc = "Exit terminal" })

K('n', '[e', vim.diagnostic.goto_prev, { desc = "Go to previous error" })
K('n', ']e', vim.diagnostic.goto_next, { desc = "Go to next error" })
