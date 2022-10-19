-- always open help in right vertical pane
vim.api.nvim_create_autocmd("Filetype", { pattern = "help", command = "wincmd L" })

-- :bp and :bn should skip quickfix buffers
vim.api.nvim_create_autocmd("FileType", { pattern = "qf", command = "set nobuflisted" })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost",
  { pattern = "*", callback = function()
    vim.highlight.on_yank { on_visual = false }
  end })
