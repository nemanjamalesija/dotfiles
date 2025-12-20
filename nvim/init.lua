require("config.lazy")

vim.filetype.add({
    extension = {
        view = "php",
        template = "php",
        scss = "sass",
    },
})

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

vim.o.background = "light"
-- vim.o.background = "dark"
