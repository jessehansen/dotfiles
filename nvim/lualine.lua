require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      'branch',
      'diff',
      {
        'diagnostics',
        sources = { 'nvim_diagnostic', 'nvim_lsp' },
      },
    },
    lualine_c = {
      {
        'filename',
        path = 1,
      },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = {},
    lualine_z = { 'location' },
  },
  -- probably not used since globalstatus is on
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        mode = 2,
      },
    },
  },
  extensions = { 'chadtree', 'fzf', 'fugitive', 'quickfix' },
})

local map = require('dotfiles.maps').map

for i = 1, 9 do
  map(
    'n',
    '<leader>' .. i,
    '<cmd>LualineBuffersJump! ' .. i .. '<cr>',
    { desc = 'Jump to buffer ' .. i, silent = true }
  )
end
map('n', '<leader>0', '<cmd>LualineBuffersJump $<cr>', { desc = 'Jump to last buffer ', silent = true })
