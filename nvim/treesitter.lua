local parsers = {}

if (vim.g.jesse_lang_rust) then
  table.insert(parsers, "rust")
end

if (vim.g.jesse_lang_js) then
  table.insert(parsers, "javascript")
  table.insert(parsers, "typescript")
  table.insert(parsers, "tsx")
  table.insert(parsers, "json")
  table.insert(parsers, "prisma")
end

require 'nvim-treesitter.configs'.setup {
  ensure_installed = parsers,

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },

  textobjects = {
    select = {
      enable = true,

      lookahead = true,

      keymaps = {
        ["af"] = { query = "@function.outer", desc = "Select entire function declaration" },
        ["if"] = { query = "@function.inner", desc = "Select function body" },
        ["ac"] = { query = "@class.outer", desc = "Select class declaration" },
        ["ic"] = { query = "@class.inner", desc = "Select class body" },
        ["ap"] = { query = "@parameter.outer", desc = "Select parameter" },
        ["ip"] = { query = "@parameter.inner", desc = "Select parameter inner" },
      },

      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },

      include_surrounding_whitespace = false,
    },
  },
}
