local lsp = require('lspconfig')
local util = require('lspconfig.util')
local coq = require('coq')
local map = require('dotfiles.maps').map
local map_many = require('dotfiles.maps').map_many

require('mason').setup()
require('mason-lspconfig').setup({
  automatic_installation = true,
})
local null_ls = require('null-ls')
local null_ls_sources = {}

-- don't make functions inside closure
local function hover_diagnostic_or_symbol_doc()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local diag = vim.diagnostic.get(0, { lnum = line - 1 })
  if next(diag) == nil then
    vim.lsp.buf.hover()
  else
    vim.diagnostic.open_float()
  end
end

local function lsp_references()
  require('telescope.builtin').lsp_references()
end

local function format_buffer()
  vim.lsp.buf.format()
end

local function set_common(client, bufnr)
  -- multiple LSPs may attach to the same buffer, but we don't need to redefine the keymaps after the first one
  if vim.b[bufnr].lsp_mapped == nil then
    map('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Go to declaration of symbol under cursor' })
    map('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to definition of symbol under cursor' })
    map(
      'n',
      'K',
      hover_diagnostic_or_symbol_doc,
      { buffer = bufnr, desc = 'Show diagnostic for current line, or documentation for symbol under cursor' }
    )
    map('n', 'L', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Show documentation for symbol under cursor' })
    map('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Go to implementation of symbol under cursor' })
    map(
      'n',
      '<space>D',
      vim.lsp.buf.type_definition,
      { buffer = bufnr, desc = 'Go to type definition of symbol under cursor' }
    )
    map_many('n', { '<space>rn', '<F2>' }, vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename symbol under cursor' })
    map('n', 'gr', lsp_references, { buffer = bufnr, desc = 'Find references to symbol under cursor' })
    map('n', '<space>f', format_buffer, { buffer = bufnr, desc = 'Format current buffer' })

    vim.b[bufnr].lsp_mapped = true
  end

  if client.server_capabilities.documentHighlightProvider then
    -- I don't have good luck with defining auto commands in lua, so just use a vim.cmd
    vim.cmd([[
    augroup lsp_document_highlight
      autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]])
  end
end

local function set_common_and_autoformat(client, bufnr)
  set_common(client, bufnr)
  vim.cmd([[
  augroup lsp_autoformat
    autocmd! BufWritePre <buffer> lua vim.lsp.buf.format()
  augroup END
  ]])
end

if vim.g.jesse_lang_go then
  lsp.gopls.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
  }))
end

if vim.g.jesse_lang_rust then
  lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities({
    settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          command = 'clippy',
        },
      },
    },
    on_attach = set_common_and_autoformat,
  }))
end

if vim.g.jesse_lang_js then
  local function organize_imports()
    local params = {
      command = '_typescript.organizeImports',
      arguments = { vim.api.nvim_buf_get_name(0) },
      title = '',
    }
    vim.lsp.buf.execute_command(params)
  end

  local function goto_source_definition()
    local position_params = vim.lsp.util.make_position_params(0)
    local params = {
      command = '_typescript.goToSourceDefinition',
      arguments = { position_params.textDocument.uri, position_params.position },
      title = '',
    }
    vim.lsp.buf.execute_command(params)
  end

  lsp.ts_ls.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
    commands = {
      OrganizeImports = {
        organize_imports,
        description = 'Organize Imports',
      },
      GoToSourceDefinition = {
        goto_source_definition,
        description = 'Go to source definition',
      },
    },
  }))
  lsp.eslint.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
  }))
  lsp.stylelint_lsp.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
  }))
  lsp.graphql.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
  }))

  table.insert(null_ls_sources, null_ls.builtins.formatting.prettierd)
end

if vim.g.jesse_lang_python then
  lsp.pylsp.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
    root_dir = function(fname)
      -- custom root_dir for some projects I contribute to
      local root_files = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
      }
      return vim.fs.root(fname, 'manage.py')
        or util.root_pattern(unpack(root_files))(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    settings = {
      pylsp = {
        plugins = {
          black = {
            enabled = true,
          },
          flake8 = {
            enabled = true,
          },
          isort = {
            enabled = true,
          },
          mypy = {
            enabled = false,
          },
          rope_autoimport = {
            enabled = true,
            memory = true,
            code_actions = {
              enabled = true,
            },
          },
          pycodestyle = {
            maxLineLength = 180,
          },
        },
      },
    },
  }))
  table.insert(
    null_ls_sources,
    null_ls.builtins.diagnostics.mypy.with({
      extra_args = function(params)
        local mypy_root = vim.fs.root(params.bufname, 'mypy.ini')
        if mypy_root then
          return { '--config-file', mypy_root .. '/mypy.ini' }
        end
        return {}
      end,
    })
  )
end

if vim.g.jesse_lang_lua then
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  lsp.lua_ls.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }))

  table.insert(null_ls_sources, null_ls.builtins.formatting.stylua)
  -- table.insert(null_ls_sources, null_ls.builtins.diagnostics.selene)
end

-- null ls should be final client setup, so it takes preference over other LSPs (for example, when formatting)
if next(null_ls_sources) ~= nil then
  null_ls.setup({
    debug = false,
    sources = null_ls_sources,
    on_attach = set_common_and_autoformat,
  })
  require('mason-null-ls').setup({
    automatic_installation = true,
    ensure_installed = {},
    auto_update = true,
  })
end

pcall(require, 'dotfiles.lsp_local')
