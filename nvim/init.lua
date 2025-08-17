vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
