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
vim.o.background = theme_mode
vim.g.theme_mode = theme_mode

require("config.lazy")

vim.filetype.add({
    extension = {
        view = "php",
        template = "php",
        scss = "sass",
    },
})
