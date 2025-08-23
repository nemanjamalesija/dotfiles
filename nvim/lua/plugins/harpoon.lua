return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        -- REQUIRED
        harpoon:setup()
        -- REQUIRED

        -- Your keymaps
        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():add()
        end, { desc = "Add file to Harpoon" })

        vim.keymap.set("n", "<leader>hm", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Toggle Harpoon menu" })

        -- Fixed select keymaps
        vim.keymap.set("n", "<M-1>", function()
            harpoon:list():select(1)
        end)
        vim.keymap.set("n", "<M-2>", function()
            harpoon:list():select(2)
        end)
        vim.keymap.set("n", "<M-3>", function()
            harpoon:list():select(3) -- Fixed: was select(2)
        end)
        vim.keymap.set("n", "<M-4>", function()
            harpoon:list():select(4) -- Fixed: was select(2)
        end)

        -- Optional: Add prev/next navigation
        vim.keymap.set("n", "<C-S-P>", function()
            harpoon:list():prev()
        end)
        vim.keymap.set("n", "<C-S-N>", function()
            harpoon:list():next()
        end)

        -- Handle swap file issues
        vim.api.nvim_create_autocmd("SwapExists", {
            callback = function()
                vim.v.swapchoice = "o" -- Open read-only
                vim.notify("File opened read-only due to existing swap file", vim.log.levels.WARN)
            end,
        })
    end,
}
