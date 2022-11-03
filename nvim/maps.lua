-- contains custom mappings
-- additional mappings present in plugin configs and in plug/ftplugin for specific file types
-- use telescope's builtin.keymaps function to see mappings

vim.g.mapleader = ","

local M = {}

---map lhs input to rhs action, including rhs in description if it is a string
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts table
local function map(mode, lhs, rhs, opts)
  -- if mapping to a string command, display the command in mapping description
  local o = vim.deepcopy(opts)
  if type(rhs) == "string" and opts and opts.desc then
    o.desc = opts.desc .. " [" .. rhs .. "]"
  end
  vim.keymap.set(mode, lhs, rhs, o)
end

M.map = map

---map each one of lhs input to rhs action
---@param mode string|table
---@param lhs_array string[]
---@param rhs string|function
---@param opts table
local function map_many(mode, lhs_array, rhs, opts)
  for _, lhs in ipairs(lhs_array) do
    map(mode, lhs, rhs, opts)
  end
end

M.map_many = map_many

-- window navigation
map("", "<C-h>", "<C-w>h", { silent = true, desc = "Move cursor one window to the left" })
map("", "<C-j>", "<C-w>j", { silent = true, desc = "Move cursor one window down" })
map("", "<C-k>", "<C-w>k", { silent = true, desc = "Move cursor one window up" })
map("", "<C-l>", "<C-w>l", { silent = true, desc = "Move cursor one window to the right" })

-- window sizing
map("", "<C-w>.", "<C-w>>", { silent = true, desc = "Grow current window" })
map("", "<C-w>,", "<C-w><", { silent = true, desc = "Shrink current window" })

-- window closing
map("n", "<leader>x", ":ccl <bar> lcl<CR>", { silent = true, desc = "Close quicklist & loclist windows" })

--quickfix navigation
map_many("n", { "<leader>>", "<leader>.", "]c" }, "<cmd>cn<CR>", { silent = true, desc = "Go to next quicklist item" })
map_many("n", { "<leader><", "<leader>,", "[c" }, "<cmd>cp<CR>",
  { silent = true, desc = "Go to previous quicklist item" })

map("c", "%%", "<C-R>=fnameescape(expand('%:h'))<CR>/", { desc = "Insert current file directory" })

map("", "<leader>/", ":noh<CR>", { silent = true, desc = "Clear search highlight" })

-- clipboard mappings
map_many("x", { "<leader>y", "<C-y>" }, '"+y', { silent = true, noremap = true, desc = "Copy to system keyboard" })
map("n", "<C-y>", '"+yy', { silent = true, noremap = true, desc = "Copy current line to system keyboard" })
map("x", "p", [[pgv"@=v:register.'y'<cr>]],
  { silent = true, noremap = true, desc = "Paste without stomping register" })

-- buffer mappings
map("n", "<Leader>h", ":bp<cr>", { silent = true, noremap = true, desc = "Next Buffer" })
map("n", "<Leader>l", ":bn<cr>", { silent = true, noremap = true, desc = "Previous Buffer" })

map("n", "<Leader>w", ":b#<bar>bd#<CR>",
  { silent = true, noremap = true, desc = "Close current buffer and switch to another" })

map("n", "<leader>a", "ggVG", { noremap = true, desc = "Select all in current buffer" })
map("n", "zz", "G", { noremap = true, desc = "Go to end of current buffer" })

map("n", "<leader>p", function()
  local value = vim.fn.expand("%")
  vim.fn.setreg("+", value)
  vim.cmd('echo "Copied \\"' .. value .. '\\" to system clipboard"')
end, { desc = "Copy current file name to system clipboard" })

-- visual mode indentation should not clear selection
map_many("v", { "<Tab>", ">" }, ">gv", { silent = true, noremap = true, desc = "Increase indent" })
map_many("v", { "<S-Tab>", "<" }, "<gv", { silent = true, noremap = true, desc = "Decrease indent" })

-- yanking in visual mode should not clear selection

-- ctrl-s saves in insert mode
map("i", "<C-s>", "<Esc>:w<CR>a", { noremap = true, desc = "Save current buffer" })

-- terminal mode mappings
map("t", "<Esc>", "<C-\\><C-n>", { noremap = true, desc = "Exit terminal" })

map('n', '[e', vim.diagnostic.goto_prev, { desc = "Go to previous error" })
map('n', ']e', vim.diagnostic.goto_next, { desc = "Go to next error" })


return M
