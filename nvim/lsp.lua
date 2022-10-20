local lsp = require "lspconfig"
local coq = require "coq"

require("mason").setup()
require("mason-lspconfig").setup({
  automatic_installation = true,
})
require("mason-null-ls").setup({
  ensure_installed = { "prettierd" },
  automatic_installation = true,
  auto_update = true,
})

local opts = { noremap = true, silent = true }

local function set_common(client, bufnr)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
    { buffer = bufnr, desc = "Go to declaration of symbol under cursor" })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition of symbol under cursor" })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = "Show documentation for symbol under cursor" })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
    { buffer = bufnr, desc = "Go to implementation of symbol under cursor" })
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition,
    { buffer = bufnr, desc = "Go to type definition of symbol under cursor" })
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol under cursor" })
  -- replaced by CodeActionMenu
  -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = "Execute Code Action"})
  vim.keymap.set('n', 'gr', function() require('telescope.builtin').lsp_references() end,
    { buffer = bufnr, desc = "Find references to symbol under cursor" })
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, { buffer = bufnr, desc = "Format current buffer" })
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    -- vim.api.nvim_create_autocmd("*", { buffer = bufnr, group = "lsp_document_highlight" })
    vim.api.nvim_create_autocmd("CursorHold",
      { buffer = bufnr, group = "lsp_document_highlight", callback = vim.lsp.buf.document_highlight })
    vim.api.nvim_create_autocmd("CursorMoved",
      { buffer = bufnr, group = "lsp_document_highlight", callback = vim.lsp.buf.clear_references })
  end
end

local function set_common_and_autoformat(client, bufnr)
  set_common(client, bufnr)
  vim.cmd [[
  augroup lsp_autoformat
    autocmd! BufWritePre <buffer> lua vim.lsp.buf.format()
  augroup END
  ]]
end

if (vim.g.jesse_lang_go) then
  lsp.gopls.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
    flags = {
      debounce_text_changes = 150
    }
  }))
end

if (vim.g.jesse_lang_rust) then
  lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities({
    cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' },
    on_attach = set_common_and_autoformat,
    flags = {
      debounce_text_changes = 150
    }
  }))
end

if (vim.g.jesse_lang_js) then
  local function organize_imports()
    local params = {
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(0) },
      title = ""
    }
    vim.lsp.buf.execute_command(params)
  end

  lsp.tsserver.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
    commands = {
      OrganizeImports = {
        organize_imports,
        description = "Organize Imports"
      }
    },
    flags = {
      debounce_text_changes = 150
    }
  }))
  lsp.stylelint_lsp.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
    flags = {
      debounce_text_changes = 150
    }
  }))
  lsp.prismals.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
    flags = {
      debounce_text_changes = 150
    }
  }))
  require("null-ls").setup({
    sources = {
      require("null-ls").builtins.formatting.eslint_d,
      require("null-ls").builtins.formatting.prettierd,
    },
    options = {
      on_attach = set_common_and_autoformat,
    }
  })
end

if (vim.g.jesse_lang_python) then
  lsp.pylsp.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
    flags = {
      debounce_text_changes = 150
    }
  }))
end

if (vim.g.jesse_lang_lua) then
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  lsp.sumneko_lua.setup(coq.lsp_ensure_capabilities({
    on_attach = set_common_and_autoformat,
    flags = {
      debounce_text_changes = 150
    },
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = runtime_path,
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }))
end

vim.cmd [[SourceMy lsp.local.vim]]
