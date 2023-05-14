local lsp = require('lsp-zero').preset({})

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

lsp.setup()

