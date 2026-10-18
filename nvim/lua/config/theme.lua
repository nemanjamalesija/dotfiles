-- Read theme mode from ~/.theme-mode (set by `theme` shell command)
-- Must be set BEFORE lazy loads plugins
local theme_file = vim.fn.expand("~/.theme-mode")
local theme_mode = "light" -- default
if vim.fn.filereadable(theme_file) == 1 then
    local content = vim.fn.readfile(theme_file)
    if content[1] == "dark" then
        theme_mode = "dark"
    end
end
-- Accent color propagates to cursor, smear-cursor, illuminate, indent-blankline
local themes = {
    dark = { colorscheme = "tokyonight-moon", accent_color = "#ea9a97" },
    light = { colorscheme = "everforest", accent_color = "#bf68d9" },
}
local theme = themes[theme_mode]

vim.o.background = theme_mode
vim.g.theme_mode = theme_mode
vim.g.colorscheme = theme.colorscheme
vim.g.accent_color = theme.accent_color

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
