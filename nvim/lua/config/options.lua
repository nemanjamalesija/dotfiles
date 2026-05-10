-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.swapfile = false
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable LazyVim's eslint extras autoformat, which uses textDocument/formatting.
-- We use the official lspconfig pattern instead (BufWritePre + LspEslintFixAll),
-- wired up in lua/plugins/lsp.lua. See lspconfig/lsp/eslint.lua for the docs.
vim.g.lazyvim_eslint_auto_format = false
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cmdheight = 0
vim.opt.updatetime = 100
vim.opt.virtualedit = "block"

-- Cursor color (theme-driven via vim.g.accent_color) - autocmd persists it across colorscheme changes
vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"

local function set_cursor_hl()
    vim.api.nvim_set_hl(0, "Cursor", { fg = "#1e1e2e", bg = vim.g.accent_color })
    vim.api.nvim_set_hl(0, "lCursor", { fg = "#1e1e2e", bg = vim.g.accent_color })
end

set_cursor_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = set_cursor_hl,
})
