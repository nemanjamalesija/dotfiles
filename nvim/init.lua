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

vim.opt.cmdheight = 0
-- vim.o.timeoutlen = 200

vim.o.background = "light"
-- vim.o.background = "dark"

if vim.env.TMUX then
    local tmux_pane = vim.env.TMUX_PANE

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        callback = function()
            local file = vim.fn.expand("%:.")
            if file ~= "" then
                vim.fn.jobstart(string.format("tmux set -t %s @current_file '%s'", tmux_pane, file), { detach = true })
            end
        end,
    })
end
