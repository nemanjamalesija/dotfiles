-- Required from init.lua before lazy.nvim starts, because plugins read these globals.

-- Accent color propagates to cursor, smear-cursor, illuminate, indent-blankline
local themes = {
    dark = { colorscheme = "tokyonight-moon", accent_color = "#ea9a97" },
    light = { colorscheme = "everforest", accent_color = "#bf68d9" },
}

-- The `theme` shell command writes ~/.theme-mode. Light is the default.
local function read_theme_mode()
    local theme_file = vim.fn.expand("~/.theme-mode")
    if vim.fn.filereadable(theme_file) == 0 then
        return "light"
    end
    local content = vim.fn.readfile(theme_file)
    return content[1] == "dark" and "dark" or "light"
end

local function set_cursor_color()
    vim.api.nvim_set_hl(0, "Cursor", { fg = "#1e1e2e", bg = vim.g.accent_color })
    vim.api.nvim_set_hl(0, "lCursor", { fg = "#1e1e2e", bg = vim.g.accent_color })
end

local theme_mode = read_theme_mode()
local theme = themes[theme_mode]

vim.o.background = theme_mode
vim.g.theme_mode = theme_mode
vim.g.colorscheme = theme.colorscheme
vim.g.accent_color = theme.accent_color

vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"
set_cursor_color()

-- A colorscheme resets the Cursor highlight, so set it again after every switch.
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("my_cursor_color", { clear = true }),
    callback = set_cursor_color,
})
