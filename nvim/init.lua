vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

require("config.lazy")

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
        vim.api.nvim_set_hl(0, group, { underline = true })
    end
end

set_illuminate_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = set_illuminate_highlights,
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
