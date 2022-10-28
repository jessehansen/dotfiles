require('Comment').setup({
  toggler = {
    line = ",ci",
    block = ",cb",
  },
  opleader = {
    line = ",ci",
    block = ",cb",
  },
  mappings = {
    basic = true,
    extra = false,
  },
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})
