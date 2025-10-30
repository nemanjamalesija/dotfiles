return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        vim.opt.shortmess:append("A")

        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():add()
        end, { desc = "Add file to Harpoon" })

        vim.keymap.set("n", "<leader>hm", function()
            harpoon.ui:toggle_quick_menu(harpoon:list(), {
                border = "single",
                title_pos = "center",
                ui_width_ratio = 0.70,
            })
        end, { desc = "Toggle Harpoon menu" })

        vim.keymap.set("n", "<leader>hh", function()
            harpoon.ui:toggle_quick_menu(harpoon:list(), {
                border = "rounded",
                title_pos = "center",
                ui_width_ratio = 0.40,
            })
        end, { desc = "Toggle Harpoon menu" })

        vim.keymap.set("n", "<M-n>", function()
            harpoon:list():next()
        end, { desc = "Harpoon next file" })

        vim.keymap.set("n", "<M-p>", function()
            harpoon:list():prev()
        end, { desc = "Harpoon previous file" })

        local function safe_select(index)
            local ok, err = pcall(function()
                harpoon:list():select(index)
            end)
            if not ok then
                if err:match("E325") then
                    vim.cmd("silent! edit!")
                    vim.schedule(function()
                        harpoon:list():select(index)
                    end)
                else
                    vim.notify("Harpoon error: " .. tostring(err), vim.log.levels.ERROR)
                end
            end
        end

        for i = 1, 5 do
            vim.keymap.set("n", "<M-" .. i .. ">", function()
                safe_select(i)
            end, { desc = "Harpoon to File " .. i })
        end
    end,
}
