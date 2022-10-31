vim.g.jesse_lang_go = false
if vim.fn.empty(vim.env.GOPATH) == 0 then
  vim.g.jesse_lang_go = true
end

vim.g.jesse_lang_rust = false
if vim.fn.isdirectory(vim.env.HOME .. "/.cargo") == 1 then
  vim.g.jesse_lang_rust = true
end

vim.g.jesse_lang_js = false
if vim.fn.executable('node') then
  vim.g.jesse_lang_js = true
end

vim.g.jesse_lang_python = false
if vim.fn.executable('python3') then
  vim.g.jesse_lang_python = true
end

-- always load lua
vim.g.jesse_lang_lua = true

pcall(require, 'dotfiles.langs_local')
