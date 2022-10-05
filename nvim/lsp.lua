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
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  if client.resolved_capabilities.document_highlight then
    vim.cmd [[
      hi! LspReferenceRead ctermbg=DarkGray
      hi! LspReferenceText ctermbg=DarkGray
      hi! LspReferenceWrite ctermbg=DarkGray
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end
end

local function set_common_and_autoformat(client, bufnr)
  set_common(client, bufnr)
  vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
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

vim.fn.SourceMy("lsp.local.vim")
