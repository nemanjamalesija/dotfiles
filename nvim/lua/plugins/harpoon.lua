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

        vim.keymap.set("n", "<leader>hh", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Toggle Harpoon menu" })

        -- Fixed select keymaps
        for i = 1, 5 do
            vim.keymap.set("n", "<M-" .. i .. ">", function()
                harpoon:list():select(i)
            end, { desc = "Harpoon to File " .. i })
        end
    end,
}
