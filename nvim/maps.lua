-- contains custom mappings
-- additional mappings present in plugin configs and in plug/ftplugin for specific file types
-- use telescope's builtin.keymaps function to see mappings

vim.g.mapleader = ","

-- window navigation
vim.keymap.set("", "<C-h>", "<C-w>h", { silent = true, desc = "Move cursor one window to the left" })
vim.keymap.set("", "<C-j>", "<C-w>j", { silent = true, desc = "Move cursor one window down" })
vim.keymap.set("", "<C-k>", "<C-w>k", { silent = true, desc = "Move cursor one window up" })
vim.keymap.set("", "<C-l>", "<C-w>l", { silent = true, desc = "Move cursor one window to the right" })

-- window sizing
vim.keymap.set("", "<C-w>.", "<C-w>>", { silent = true, desc = "Grow current window" })
vim.keymap.set("", "<C-w>,", "<C-w><", { silent = true, desc = "Shrink current window" })

-- window closing
vim.keymap.set("n", "<leader>x", ":ccl <bar> lcl<CR>", { silent = true, desc = "Close quicklist & loclist windows" })

--quickfix navigation
vim.keymap.set("n", "<leader>>", "<cmd>cn<CR>", { silent = true, desc = "Go to next quicklist item" })
vim.keymap.set("n", "<leader>.", "<cmd>cn<CR>", { silent = true, desc = "Go to next quicklist item" })
vim.keymap.set("n", "]c", "<cmd>cn<CR>", { silent = true, desc = "Go to next quicklist item" })
vim.keymap.set("n", "<leader><", "<cmd>cp<CR>", { silent = true, desc = "Go to previous quicklist item" })
vim.keymap.set("n", "<leader>,", "<cmd>cp<CR>", { silent = true, desc = "Go to previous quicklist item" })
vim.keymap.set("n", "[c", "<cmd>cp<CR>", { silent = true, desc = "Go to previous quicklist item" })

vim.keymap.set("c", "%%", "<C-R>=fnameescape(expand('%:h'))<CR>/", { desc = "Insert current file directory" })

vim.keymap.set("", "<leader>/", ":noh<CR>", { silent = true, desc = "Clear search highlight" })

-- clipboard mappings
vim.keymap.set("x", "<leader>y", '"+y', { silent = true, noremap = true, desc = "Copy to system keyboard" })
vim.keymap.set("x", "<C-y>", '"+y', { silent = true, noremap = true, desc = "Copy to system keyboard" })
vim.keymap.set("n", "<C-y>", '"+yy', { silent = true, noremap = true, desc = "Copy current line to system keyboard" })
vim.keymap.set("x", "p", [[pgv"@=v:register.'y'<cr>]],
  { silent = true, noremap = true, desc = "Paste without stomping register" })

-- buffer mappings
vim.keymap.set("n", "<silent>", "<Leader>h :bp<cr>", { silent = true, noremap = true, desc = "Next Buffer" })
vim.keymap.set("n", "<silent>", "<Leader>l :bn<cr>", { silent = true, noremap = true, desc = "Previous Buffer" })

vim.keymap.set("n", "<Leader>w", ":b#<bar>bd#<CR>",
  { silent = true, noremap = true, desc = "Close current buffer and switch to another" })

vim.keymap.set("n", "<leader>a", "ggVG", { noremap = true, desc = "Select all in current buffer" })
vim.keymap.set("n", "zz", "G", { noremap = true, desc = "Go to end of current buffer" })

vim.keymap.set("n", "<leader>p", function()
  local value = vim.fn.expand("%")
  vim.fn.setreg("+", value)
  vim.cmd('echo "Copied \\"' .. value .. '\\" to system clipboard"')
end, { desc = "Copy current file name to system clipboard" })

-- visual mode indentation should not clear selection
vim.keymap.set("v", "<Tab>", ">gv", { silent = true, desc = "Increase indent" })
vim.keymap.set("v", "<S-Tab>", "<gv", { silent = true, desc = "Decrease indent" })
vim.keymap.set("v", ">", ">gv", { silent = true, noremap = true, desc = "Increase indent" })
vim.keymap.set("v", "<", "<gv", { silent = true, noremap = true, desc = "Decrease indent" })

-- ctrl-s saves in insert mode
vim.keymap.set("i", "<C-s>", "<ESC>:w<CR>a", { noremap = true, desc = "Save current buffer" })

-- terminal mode mappings
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, desc = "Exit terminal" })

vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, { desc = "Go to previous error" })
vim.keymap.set('n', ']e', vim.diagnostic.goto_next, { desc = "Go to next error" })

vim.keymap.set("", "<space>ca", "<cmd>CodeActionMenu<CR>", { silent = true, desc = "Execute Code Action" })
vim.keymap.set("", "<M-a>", "<cmd>CodeActionMenu<CR>",
  { silent = true, noremap = true, desc = "Execute Code Action" })
