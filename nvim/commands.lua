vim.api.nvim_create_user_command('ShowErrors', function()
  vim.diagnostic.setqflist({ open = true })
end, { nargs = 0, desc = "Show Diagnostics in quicklist" })
