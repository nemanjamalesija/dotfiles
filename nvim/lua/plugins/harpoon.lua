return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        -- Your keymaps
        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():add()
        end, { desc = "Add file to Harpoon" })

        vim.keymap.set("n", "<leader>hm", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Toggle Harpoon menu" })

        -- Fixed select keymaps
        for i = 1, 5 do
            vim.keymap.set("n", "<M-" .. i .. ">", function()
                harpoon:list():select(i)
            end, { desc = "Harpoon to File " .. i })
        end

        -- Optional: Add prev/next navigation
        vim.keymap.set("n", "<M-l>", function()
            harpoon:list():prev()
        end)
        vim.keymap.set("n", "<M-h>", function()
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
