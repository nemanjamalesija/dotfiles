local M = {
    "akinsho/toggleterm.nvim",
}
M.config = function()
    local tg = require("toggleterm")
    if not tg then
        return
    end
    local terminal = require("toggleterm.terminal")

    local Terminal = terminal.Terminal
    tg.setup({
        size = 13,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = "1",
        start_in_insert = true,
        persist_size = true,
        direction = "horizontal",
        on_open = function()
            vim.cmd.startinsert()
        end,
    })
end

return M
