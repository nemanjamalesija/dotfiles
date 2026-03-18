-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.swapfile = false
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cmdheight = 0

-- Cursor color (magenta) - use autocommand so it persists after colorscheme changes
vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"

local function set_cursor_hl()
    vim.api.nvim_set_hl(0, "Cursor", { fg = "#1e1e2e", bg = "#bf68d9" })
    vim.api.nvim_set_hl(0, "lCursor", { fg = "#1e1e2e", bg = "#bf68d9" })
end

set_cursor_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = set_cursor_hl,
})
