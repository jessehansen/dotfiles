local lsp = require('lspconfig')
local coq = require('coq')
local map = require('dotfiles.maps').map
local map_many = require('dotfiles.maps').map_many

local AG = vim.api.nvim_create_augroup
local AC = vim.api.nvim_create_autocmd

require('mason').setup()
require('mason-lspconfig').setup({
  automatic_installation = true,
})
local null_ls = require('null-ls')
local null_ls_sources = {}

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

-- wrap vim.lsp.buf.* functions so they don't return true, clearing the autocmd
local function format_buffer()
  vim.lsp.buf.format()
end

local function document_highlight()
  vim.lsp.buf.document_highlight()
end

local function clear_references()
  vim.lsp.buf.clear_references()
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
    map('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Go to implementation of symbol under cursor' })
    map(
      'n',
      '<space>D',
      vim.lsp.buf.type_definition,
      { buffer = bufnr, desc = 'Go to type definition of symbol under cursor' }
    )
    map_many('n', { '<space>rn', '<F2>' }, vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename symbol under cursor' })
    map_many(
      '',
      { '<space>ca', '<M-a>' },
      '<cmd>CodeActionMenu<cr>',
      { buffer = bufnr, silent = true, desc = 'Execute Code Action' }
    )
    map('n', 'gr', lsp_references, { buffer = bufnr, desc = 'Find references to symbol under cursor' })
    map('n', '<space>f', format_buffer, { buffer = bufnr, desc = 'Format current buffer' })

    vim.b[bufnr].lsp_mapped = true
  end
  if client.server_capabilities.documentHighlightProvider and vim.b[bufnr].lsp_highlight == nil then
    AC('CursorHold', {
      buffer = bufnr,
      callback = document_highlight,
      desc = 'Highlight symbol under cursor',
    })
    AC('CursorMoved', {
      buffer = bufnr,
      callback = clear_references,
      desc = 'Clear symbol highlight',
    })

    vim.b[bufnr].lsp_highlight = true
  end
end

local function set_common_and_autoformat(client, bufnr)
  set_common(client, bufnr)
  if vim.b[bufnr].lsp_autoformat == nil then
    AC('BufWritePre', {
      buffer = bufnr,
      callback = format_buffer,
      desc = 'Format on save',
    })

    vim.b[bufnr].lsp_autoformat = true
  end
end

if vim.g.jesse_lang_go then
  lsp.gopls.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
  }))
end

if vim.g.jesse_lang_rust then
  lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities({
    cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' },
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

  lsp.tsserver.setup(coq.lsp_ensure_capabilities({
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
  lsp.stylelint_lsp.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
    -- TODO: Disable code actions associated with this LSP
  }))
  lsp.prismals.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
  }))

  table.insert(null_ls_sources, null_ls.builtins.formatting.prettierd)

  table.insert(null_ls_sources, null_ls.builtins.diagnostics.eslint_d)
  table.insert(null_ls_sources, null_ls.builtins.formatting.eslint_d)
  table.insert(null_ls_sources, null_ls.builtins.code_actions.eslint_d)
end

if vim.g.jesse_lang_python then
  lsp.pylsp.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
  }))
end

if vim.g.jesse_lang_lua then
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  lsp.sumneko_lua.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = runtime_path,
        },
        diagnostics = {
          globals = { 'vim' },
          neededFileStatus = {
            ['codestyle-check'] = 'Any',
          },
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
  table.insert(null_ls_sources, null_ls.builtins.diagnostics.selene)
end

-- null ls should be final client setup, so it takes preference over other LSPs (for example, when formatting)
if next(null_ls_sources) ~= nil then
  null_ls.setup({
    debug = true,
    sources = null_ls_sources,
    on_attach = set_common_and_autoformat,
  })
  require('mason-null-ls').setup({
    automatic_installation = true,
    auto_update = true,
  })
end

pcall(require, 'dotfiles.lsp_local')
