-- contains custom mappings
-- additional mappings present in plugin configs and in plug/ftplugin for specific file types
-- use telescope's builtin.keymaps function to see mappings

vim.g.mapleader = ','

local M = {}

---map lhs input to rhs action, including rhs in description if it is a string
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts table
local function map(mode, lhs, rhs, opts)
  -- if mapping to a string command, display the command in mapping description
  local o = vim.deepcopy(opts)
  if type(rhs) == 'string' and opts and opts.desc then
    o.desc = opts.desc .. ' [' .. rhs .. ']'
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
map('', '<C-h>', '<C-w>h', { silent = true, desc = 'Move cursor one window to the left' })
map('', '<C-j>', '<C-w>j', { silent = true, desc = 'Move cursor one window down' })
map('', '<C-k>', '<C-w>k', { silent = true, desc = 'Move cursor one window up' })
map('', '<C-l>', '<C-w>l', { silent = true, desc = 'Move cursor one window to the right' })

-- window sizing
map('', '<C-w>.', '<C-w>>', { silent = true, desc = 'Grow current window' })
map('', '<C-w>,', '<C-w><', { silent = true, desc = 'Shrink current window' })

-- window closing
map('n', '<leader>x', ':ccl <bar> lcl<CR>', { silent = true, desc = 'Close quicklist & loclist windows' })

--quicklist navigation
map_many('n', { '<leader>>', '<leader>.', ']c' }, '<cmd>cn<CR>', { silent = true, desc = 'Go to next quicklist item' })
map_many(
  'n',
  { '<leader><', '<leader>,', '[c' },
  '<cmd>cp<CR>',
  { silent = true, desc = 'Go to previous quicklist item' }
)

map('c', '%%', "<C-R>=fnameescape(expand('%:h'))<CR>/", { desc = 'Insert current file directory' })

map('', '<leader>/', ':nohlsearch<CR>', { silent = true, desc = 'Clear search highlight' })

-- clipboard mappings
map_many('x', { '<leader>y', '<C-y>' }, '"+y', { silent = true, remap = false, desc = 'Copy to system keyboard' })
map('n', '<C-y>', '"+yy', { silent = true, remap = false, desc = 'Copy current line to system keyboard' })
map('x', 'p', [[pgv"@=v:register.'y'<cr>]], { silent = true, remap = false, desc = 'Paste without stomping register' })

-- buffer mappings
map('n', '<Leader>h', ':bp<cr>', { silent = true, remap = false, desc = 'Next Buffer' })
map('n', '<Leader>l', ':bn<cr>', { silent = true, remap = false, desc = 'Previous Buffer' })

map(
  'n',
  '<Leader>w',
  ':b#<bar>bd#<CR>',
  { silent = true, remap = false, desc = 'Close current buffer and switch to another' }
)

map('n', '<leader>a', 'ggVG', { remap = false, desc = 'Select all in current buffer' })
map('n', 'zz', 'G', { remap = false, desc = 'Go to end of current buffer' })

map('n', '<leader>p', function()
  local value = vim.fn.expand('%')
  vim.fn.setreg('+', value)
  vim.cmd('echo "Copied \\"' .. value .. '\\" to system clipboard"')
end, { desc = 'Copy current file name to system clipboard' })

-- visual mode indentation should not clear selection
map_many('v', { '<Tab>', '>' }, '>gv', { silent = true, remap = false, desc = 'Increase indent' })
map_many('v', { '<S-Tab>', '<' }, '<gv', { silent = true, remap = false, desc = 'Decrease indent' })

-- yanking in visual mode should not clear selection

-- ctrl-s saves in insert mode
map('i', '<C-s>', '<Esc>:w<CR>a', { remap = false, desc = 'Save current buffer' })
map('i', '<C-r>', '<C-r><C-o>', { remap = false, desc = 'Insert register without indentation' })

-- terminal mode mappings
map('t', '<Esc>', '<C-\\><C-n>', { remap = false, desc = 'Exit terminal' })

map('n', '[e', vim.diagnostic.goto_prev, { desc = 'Go to previous error' })
map('n', ']e', vim.diagnostic.goto_next, { desc = 'Go to next error' })

map('n', ',u', "a<c-r>=tolower(trim(system('uuidgen')))<CR><Esc>", { remap = false, desc = 'Insert UUID after cursor' })
map(
  'v',
  ',u',
  "c<c-r>=tolower(trim(system('uuidgen')))<CR><Esc>",
  { remap = false, desc = 'Overwrite selection with UUID' }
)
map(
  'n',
  ',U',
  "i<c-r>=tolower(trim(system('uuidgen')))<CR><Esc>",
  { remap = false, desc = 'Insert UUID before cursor' }
)

map('i', '<C-u>', "<c-r>=tolower(trim(system('uuidgen')))<cr>", { desc = 'Insert UUID' })

return M
