return {
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    style_preset = require("bufferline").style_preset.bufferline,
                    modified_icon = "● ",
                    tab_size = 18,
                    diagnostics = false,
                    mappings = true,
                    separator_style = "slope",
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            text_align = "center",
                            separator = false,
                        },
                    },
                    show_buffer_icons = false,
                    show_buffer_close_icons = false,
                    show_tab_indicators = true,
                    always_show_bufferline = true,
                },
                -- highlights = {
                --   fill = {
                --     bg = "#fdf6e3",
                --     fg = "#fdf6e3",
                --   },
                -- },
            })

            -- Keymaps
            vim.api.nvim_set_keymap(
                "n",
                "<M-h>",
                ":bprevious<CR>",
                { desc = "Focus buffer left", noremap = true, silent = true }
            )
            vim.api.nvim_set_keymap(
                "n",
                "<M-l>",
                ":bnext<CR>",
                { desc = "Focus buffer on the right", noremap = true, silent = true }
            )
            vim.api.nvim_set_keymap(
                "n",
                "<C-M-h>",
                ":BufferLineMovePrev<CR>",
                { desc = "Move buffer to the left", noremap = true, silent = true }
            )
            vim.api.nvim_set_keymap(
                "n",
                "<C-M-l>",
                ":BufferLineMoveNext<CR>",
                { desc = "Move buffer to the right", noremap = true, silent = true }
            )
            vim.keymap.set("n", "<M-w>", function()
                require("mini.bufremove").delete(0, false)
            end, { desc = "Delete buffer" }) -- WezTerm Alt + w

            vim.keymap.set("n", "∑", function()
                require("mini.bufremove").delete(0, false)
            end, { desc = "Delete buffer" }) -- Ghost terminal interprets alt as ∑
        end,
    },
}
