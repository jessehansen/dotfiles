require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<Esc>"] = "close", -- this disables n-mode - I don't find myself needing it very often, and <C-/><C-n> works for those cases
      }
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  },
  preview = {
    check_mime_type = false,
  },
}
require('telescope').load_extension('fzf')

-- key maps
local builtin = require('telescope.builtin')
vim.keymap.set('n', 'ff', builtin.find_files, { desc = "Find file" })
vim.keymap.set('n', 'fg', builtin.live_grep, { desc = "Find string" })
vim.keymap.set('n', 'fb', builtin.buffers, { desc = "Find buffer" })
vim.keymap.set('n', 'fh', builtin.help_tags, { desc = "Find help tags" })

vim.keymap.set('', '<C-p>', builtin.find_files, { desc = "Find file" })
vim.keymap.set('', '<M-p>', builtin.commands, { desc = "Command Palette" })
vim.keymap.set('', '<C-s>', builtin.git_status, { desc = "Find Edited File (using `git status`)" })
vim.keymap.set('', '<M-s>', builtin.git_files, { desc = "Find git-tracked file" })
vim.keymap.set('', '<C-e>', builtin.oldfiles, { desc = "Find recently used file" })
vim.keymap.set('', '<M-f>', builtin.live_grep, { desc = "Find string" })

vim.keymap.set('n', '<leader>m', builtin.keymaps, { desc = "Find keymapping" })
vim.keymap.set('n', '<leader><tab>', function() builtin.keymaps { modes = { "n" } } end,
  { desc = "Find current mode mappings" })
vim.keymap.set('x', '<leader><tab>', function() builtin.keymaps { modes = { "x" } } end,
  { desc = "Find current mode mappings" })
vim.keymap.set('c', '<C-/>', function() builtin.keymaps { modes = { "c" } } end,
  { desc = "Find current mode mappings" })

vim.keymap.set('n', '<leader>g', function()
  local word = vim.fn.expand('<cword>')
  builtin.grep_string { search = word }
end, { desc = "Search for word under cursor" })

local function get_visual_selection()
  -- Yank current visual selection into the 'v' register
  --
  -- Note that this makes no effort to preserve this register
  vim.cmd('noau normal! "vy"')

  return vim.fn.getreg('v')
end

vim.keymap.set('x', '<leader>g', function()
  local selected_text = get_visual_selection()
  builtin.grep_string {
    use_regex = true,
    search = vim.fn.substitute(-- replace whitespace with \s+
      vim.fn.escape(selected_text, '\\.*$^~[{'), -- escape special chars
      [[\_s\+]],
      [[\\s+]],
      'g')
  }
end, { desc = "Search for selected string" })

vim.api.nvim_create_user_command("Rg", function(opts)
  builtin.grep_string { search = opts.args, use_regex = not opts.bang }
end, { nargs = "+", bang = true, desc = "Find in files - use :Rg! to disable regex" })
