vim.api.nvim_create_augroup("dotfiles", { clear = true })
-- always open help in right vertical pane
vim.api.nvim_create_autocmd("Filetype", { pattern = "help", command = "wincmd L", group = "dotfiles" })

-- :bp and :bn should skip quickfix buffers
vim.api.nvim_create_autocmd("FileType", { pattern = "qf", command = "set nobuflisted", group = "dotfiles" })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost",
  { pattern = "*", group = "dotfiles", callback = function()
    vim.highlight.on_yank { on_visual = true, timeout = 500 }
  end })
