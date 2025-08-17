return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-tree.lua",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local nvim_tree_api = require("nvim-tree.api")

        telescope.setup({
            defaults = {
                file_ignore_patterns = { "node_modules" },
                layout_strategy = "vertical",
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--ignore-case",
                },
            },
        })

        telescope.load_extension("fzf")

        -- Keymaps
        vim.keymap.set("n", "<leader><leader>", function()
            require("telescope.builtin").find_files({
                hidden = true,
                no_ignore = true,
                follow = true,
                find_command = {
                    "fd",
                    "--type",
                    "f",
                    "--hidden",
                    "--follow",
                    "--exclude",
                    "__install",
                    "--exclude",
                    "__project",
                    "--exclude",
                    "_db_diff",
                    "--exclude",
                    "_cache",
                    "--exclude",
                    "public/dist",
                    "--exclude",
                    "_local_cache",
                    "--exclude",
                    "node_modules",
                    "--exclude",
                    "migrations",
                    "--exclude",
                    "logs",
                    "--exclude",
                    "var/translations-cache",
                    "--exclude",
                    "symfony/var/cache",
                    "--exclude",
                    "var/minimalna-dumps",
                    "--exclude",
                    "data/dynamic_ad",
                    "--exclude",
                    "app/config/category",
                    "--exclude",
                    "data/dynamic_ad_repo",
                    "--exclude",
                    "tests",
                },
            })
        end, { desc = "Find files (clean search, exclude dist/node_modules/etc)" })

        -- Grep find all
        vim.keymap.set("n", "<leader>F", function()
            require("telescope.builtin").live_grep({
                additional_args = function()
                    return {
                        "--hidden",
                        "--no-ignore",
                        "--glob",
                        "!**/__install/**",
                        "--glob",
                        "!**/__project/**",
                        "--glob",
                        "!**/_db_diff/**",
                        "--glob",
                        "!**/_cache/**",
                        "--glob",
                        "!**/public/dist/**",
                        "--glob",
                        "!**/_local_cache/**",
                        "--glob",
                        "!**/node_modules/**",
                        "--glob",
                        "!**/migrations/**",
                        "--glob",
                        "!**/logs/**",
                        "--glob",
                        "!**/symfony/var/cache/**",
                        "--glob",
                        "!**/var/minimalna-dumps/**",
                        "--glob",
                        "!**/data/dynamic_ad/**",
                        "--glob",
                        "!**/app/config/category/**",
                        "--glob",
                        "!**/data/dynamic_ad_repo/**",
                        "--glob",
                        "!**/tests/**",
                        "--glob",
                        "!**/dist/**",
                        "--glob",
                        "!**/ssr-dist/**",
                        "--glob",
                        "!**/var/translations-cache/**",
                        "--glob",
                        "!**/.git/logs/**",
                        "--glob",
                        "!**/var/cache/dev/**",
                        "-F", -- Treat query as literal string, not regex
                    }
                end,
            })
        end, { desc = "Live grep (literal search, exclude junk)" })

        -- Fuzzy search in current buffer
        vim.keymap.set(
            "n",
            "<leader>f",
            require("telescope.builtin").current_buffer_fuzzy_find,
            { desc = "Fuzzy search in current buffer" }
        )

        -- grep find all in specific folder
        vim.keymap.set("n", "<leader>fd", function()
            local dir = vim.fn.input("grep directory: ")
            vim.cmd("redraw") -- Clears the command-line input prompt
            require("telescope.builtin").live_grep({
                search_dirs = { dir },
            })
        end, { desc = "live grep in user directory" })
    end,
}
