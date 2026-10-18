local function toggle_menu(menu_opts)
    local harpoon = require("harpoon")
    harpoon.ui:toggle_quick_menu(harpoon:list(), menu_opts)
end

local function safe_select(index)
    local harpoon = require("harpoon")
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

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = function()
        local keys = {
            {
                "<leader>ha",
                function()
                    require("harpoon"):list():add()
                end,
                desc = "Add file to Harpoon",
            },
            {
                "<leader>hm",
                function()
                    toggle_menu({ border = "single", title_pos = "center", ui_width_ratio = 0.70 })
                end,
                desc = "Toggle Harpoon menu",
            },
            {
                "<leader>hh",
                function()
                    toggle_menu({ border = "rounded", title_pos = "center", ui_width_ratio = 0.40 })
                end,
                desc = "Toggle Harpoon menu",
            },
            {
                "<leader>hn",
                function()
                    require("harpoon"):list():next()
                end,
                desc = "Harpoon next file",
            },
            {
                "<leader>hp",
                function()
                    require("harpoon"):list():prev()
                end,
                desc = "Harpoon previous file",
            },
        }

        for i = 1, 5 do
            table.insert(keys, {
                "<leader>h" .. i,
                function()
                    safe_select(i)
                end,
                desc = "Harpoon to File " .. i,
            })
        end
        return keys
    end,
}
