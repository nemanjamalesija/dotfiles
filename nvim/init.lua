vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

require("config.lazy")

vim.diagnostic.config({
    underline = false,
    severity_sort = true,
})

vim.filetype.add({
    extension = {
        view = "php",
        template = "php",
        scss = "sass",
    },
})

local function set_illuminate_highlights()
    for _, group in ipairs({
        "IlluminatedWordText",
        "IlluminatedWordRead",
        "IlluminatedWordWrite",
        "LspReferenceText",
        "LspReferenceRead",
        "LspReferenceWrite",
    }) do
        vim.api.nvim_set_hl(0, group, { underline = true, bg = "NONE", fg = "NONE", sp = "NONE" })
    end
end

set_illuminate_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = set_illuminate_highlights,
})

local function toggle_bat_theme()
    if vim.opt.background:get() == "light" then
        vim.env.BAT_THEME = "Solarized (light)"
    else
        vim.env.BAT_THEME = ""
    end
end

-- Set initial BAT_THEME
toggle_bat_theme()

vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    signs = true,
    update_in_insert = false,
    float = {
        max_width = 80,
        wrap = true,
        border = "rounded",
    },
})

-- vim.o.background = "light"
if vim.env.COLORFGBG then
    -- Basic check: If first number is "15" it's light, if "0" it's dark
    local fg, bg = vim.env.COLORFGBG:match("^(%d+);(%d+)$")
    if fg and bg then
        if tonumber(fg) > tonumber(bg) then
            vim.o.background = "light"
        else
            vim.o.background = "dark"
        end
    end
end
