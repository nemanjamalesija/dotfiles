return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup({})

        -- Telescope integration
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers")
                .new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                })
                :find()
        end

        vim.keymap.set("n", "<leader>hm", function()
            require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end, { desc = "Toggle Harpoon menu" })
        vim.keymap.set("n", "<leader>ho", function()
            toggle_telescope(harpoon:list())
        end, { desc = "Open harpoon with Telescope" })
        vim.keymap.set("n", "<leader>ha", function()
            require("harpoon"):list():add()
        end, { desc = "Add file to Harpoon" })
        vim.keymap.set("n", "<M-1>", function()
            require("harpoon"):list():select(1)
        end)
        vim.keymap.set("n", "<M-2>", function()
            require("harpoon"):list():select(2)
        end)
        vim.keymap.set("n", "<M-3>", function()
            require("harpoon"):list():select(2)
        end)
        vim.keymap.set("n", "<M-4>", function()
            require("harpoon"):list():select(2)
        end)
    end,
}
