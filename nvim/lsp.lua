local lsp = require("lspconfig")
local coq = require("coq")
local map = require("dotfiles.maps").map
local map_many = require("dotfiles.maps").map_many

-- local AG = vim.api.nvim_create_augroup
-- local AC = vim.api.nvim_create_autocmd

require("mason").setup()
require("mason-lspconfig").setup({
  automatic_installation = true,
})
require("mason-null-ls").setup({
  ensure_installed = { "prettierd" },
  automatic_installation = true,
  auto_update = true,
})

local function set_common(client) --, bufnr
  map('n', 'gD', vim.lsp.buf.declaration,
    { buffer = true, desc = "Go to declaration of symbol under cursor" })
  map('n', 'gd', vim.lsp.buf.definition, { buffer = true, desc = "Go to definition of symbol under cursor" })
  map('n', 'K', vim.lsp.buf.hover, { buffer = true, desc = "Show documentation for symbol under cursor" })
  map('n', 'gi', vim.lsp.buf.implementation,
    { buffer = true, desc = "Go to implementation of symbol under cursor" })
  map('n', '<space>D', vim.lsp.buf.type_definition,
    { buffer = true, desc = "Go to type definition of symbol under cursor" })
  map('n', '<space>rn', vim.lsp.buf.rename, { buffer = true, desc = "Rename symbol under cursor" })
  map_many('', { '<space>ca', '<M-a>' }, '<cmd>CodeActionMenu<cr>',
    { buffer = true, silent = true, desc = "Execute Code Action" })
  map('n', 'gr', function() require('telescope.builtin').lsp_references() end,
    { buffer = true, desc = "Find references to symbol under cursor" })
  map('n', '<space>f', function() vim.lsp.buf.format() end, { buffer = true, desc = "Format current buffer" })
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd [[
    augroup lsp_document_highlight
      autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]]
    -- AG("lsp_document_highlight", { clear = true })
    -- AC("CursorHold",
    --   { buffer = bufnr, group = "lsp_document_highlight", callback = vim.lsp.buf.document_highlight,
    --     desc = "Highlight symbol under cursor" })
    -- AC("CursorMoved",
    --   { buffer = bufnr, group = "lsp_document_highlight", callback = vim.lsp.buf.clear_references,
    --     desc = "Clear symbol highlight" })
  end
end

local function set_common_and_autoformat(client) -- ,bufnr
  set_common(client)
  -- TODO: This should be in lua, but it doesn't alwas trigger with
  -- nvim_create_autocmd for some reason (I'm probably doing something wrong)
  vim.cmd [[
  augroup lsp_autoformat
    autocmd! BufWritePre <buffer> lua vim.lsp.buf.format()
  augroup END
  ]]

  -- AG("lsp_autoformat", { clear = true })
  -- AC("BufWritePre",
  --   {
  --     buffer = bufnr,
  --     group = "lsp_autoformat",
  --     callback = function()
  --       vim.lsp.buf.format()
  --       return false
  --     end,
  --     desc = "Format on save",
  --   })
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

  local function goto_source_definition()
    local position_params = vim.lsp.util.make_position_params(0)
    local params = {
      command = "_typescript.goToSourceDefinition",
      arguments = { position_params.textDocument.uri, position_params.position },
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
      },
      GoToSourceDefinition = {
        goto_source_definition,
        description = "Go to source definition"
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
          neededFileStatus = {
            ["codestyle-check"] = "Any",
          }
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

pcall(require, 'dotfiles.lsp_local')
