-- Hover popups
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.wrap = true
    opts.border = "single"
    opts.max_width = 90

    local bufnr, winid = orig_util_open_floating_preview(contents, syntax, opts, ...)
    return bufnr, winid
end

return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        {
            "rcarriga/nvim-notify",
            config = function()
                require("notify").setup({
                    timeout = 3000,
                    max_height = function()
                        return math.floor(vim.o.lines * 0.75)
                    end,
                    max_width = function()
                        return math.floor(vim.o.columns * 0.60)
                    end,
                    on_open = function(win)
                        vim.api.nvim_win_set_config(win, { focusable = true })
                    end,
                    render = "default",
                    stages = "fade",
                    level = vim.log.levels.WARN,
                    merge_duplicates = false,
                })
            end,
        },
    },
    opts = {
        cmdline = {
            enabled = true,
            view = "cmdline",
            format = {
                search_down = { view = "cmdline" },
                search_up = { view = "cmdline" },
            },
        },
        lsp = {
            signature = {
                enabled = false,
            },
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = false,
        },
    },
    keys = {
        {
            "<leader>na",
            function()
                require("noice").cmd("all")
            end,
            desc = "Noice: Show all notifications",
        },
        {
            "<leader>nc",
            function()
                require("noice").cmd("dismiss")
            end,
            desc = "Noice: Clear all notifications",
        },
        {
            "<leader>nh",
            function()
                require("noice").cmd("history")
            end,
            desc = "Noice: Show notification history",
        },
        {
            "<leader>nl",
            function()
                require("noice").cmd("last")
            end,
            desc = "Noice: Show last notification",
        },
        {
            "<leader>nt",
            function()
                require("noice").cmd("fzf")
            end,
            desc = "Noice: Fzf picker",
        },
    },
}
