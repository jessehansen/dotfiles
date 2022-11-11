require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = 'move_selection_next',
        ['<C-k>'] = 'move_selection_previous',
        ['<Esc>'] = 'close', -- this disables n-mode - <C-/><C-n> works when necessary
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
  preview = {
    check_mime_type = false,
  },
})
require('telescope').load_extension('fzf')

-- key maps
local builtin = require('telescope.builtin')
local map = require('dotfiles.maps').map
local map_many = require('dotfiles.maps').map_many
map_many('n', { 'ff', '<C-p>' }, builtin.find_files, { desc = 'Find file' })
map_many('n', { 'fc', '<M-p>' }, builtin.commands, { desc = 'Command Palette' })
map_many('n', { 'fs', '<C-s>' }, builtin.git_status, { desc = 'Find Edited File (using `git status`)' })
map_many('n', { 'fS', '<M-s>' }, builtin.git_files, { desc = 'Find git-tracked file' })
map_many('n', { 'fe', '<C-e>' }, function()
  builtin.oldfiles({ cwd_only = true })
end, { desc = 'Find recently used file (oldfiles)' })
map_many('n', { 'fg', '<M-f>' }, builtin.live_grep, { desc = 'Find string' })
map_many('n', { 'fm', '<leader>m' }, function()
  builtin.keymaps({ show_plug = false })
end, { desc = 'Find keymapping' })
map('n', 'fb', builtin.buffers, { desc = 'Find buffer' })
map('n', 'fh', builtin.help_tags, { desc = 'Find help tags' })
map('n', 'fr', builtin.registers, { desc = 'Find registers' })
map('n', 'fl', builtin.current_buffer_fuzzy_find, { desc = 'Find line' })

map('n', '<leader><tab>', function()
  builtin.keymaps({ modes = { 'n' }, show_plug = false })
end, { desc = 'Find normal mode mappings' })
map('x', '<leader><tab>', function()
  builtin.keymaps({ modes = { 'x', show_plug = false } })
end, { desc = 'Find visual mode mappings' })
map('o', '<leader><tab>', function()
  builtin.keymaps({ modes = { 'o', show_plug = false } })
end, { desc = 'Find operator mode mappings' })
map('c', '<C-/>', function()
  builtin.keymaps({ modes = { 'c', show_plug = false } })
end, { desc = 'Find command mode mappings' })

map('n', '<leader>g', function()
  local word = vim.fn.expand('<cword>')
  builtin.grep_string({ search = word })
end, { desc = 'Search for word under cursor' })

local function get_visual_selection()
  -- Yank current visual selection into the 'v' register
  --
  -- Note that this makes no effort to preserve this register
  vim.cmd('noau normal! "vy"')

  return vim.fn.getreg('v')
end

map('x', '<leader>g', function()
  local selected_text = get_visual_selection()
  builtin.grep_string({
    use_regex = true,
    search = vim.fn.substitute(-- replace whitespace with \s+
      vim.fn.escape(selected_text, '\\.*$^~[{'), -- escape special chars
      [[\_s\+]],
      [[\\s+]],
      'g'
    ),
  })
end, { desc = 'Search for selected string' })

vim.api.nvim_create_user_command('Rg', function(opts)
  builtin.grep_string({ search = opts.args, use_regex = not opts.bang })
end, { nargs = '+', bang = true, desc = 'Find in files - use :Rg! to disable regex' })
