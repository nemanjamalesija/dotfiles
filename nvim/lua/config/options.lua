-- Loaded before lazy.nvim starts. LazyVim's defaults:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Files
vim.opt.swapfile = false

-- Keep undo history on disk so undo reaches back into previous sessions.
vim.o.undodir = vim.fn.expand("~/.config/nvim/.undodir")
vim.o.undofile = true

vim.filetype.add({
    extension = {
        view = "php",
        template = "php",
        scss = "sass",
    },
})

-- Editing
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- UI
vim.opt.cmdheight = 0
vim.opt.updatetime = 100

-- Default border for every float that does not set its own.
-- fzf-lua and noice draw their own windows and ignore this.
vim.o.winborder = "rounded"

-- Stop Vim counting lines at us. The default of 2 means every yank or delete
-- of three or more lines announces itself, which is most of them.
vim.o.report = 9999

-- Plugin switches
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable LazyVim's eslint extras autoformat, which uses textDocument/formatting.
-- We use the official lspconfig pattern instead (BufWritePre + LspEslintFixAll),
-- wired up in lua/plugins/lsp.lua. See lspconfig/lsp/eslint.lua for the docs.
vim.g.lazyvim_eslint_auto_format = false
