local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                git = {
                    enable = false,
                },
                sort = {
                    sorter = "case_sensitive",
                },
                view = {
                    float = {
                        enable = true,
                        open_win_config = function()
                            local screen_w = vim.opt.columns:get()
                            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                            local window_w = screen_w * WIDTH_RATIO
                            local window_h = screen_h * HEIGHT_RATIO
                            local window_w_int = math.floor(window_w)
                            local window_h_int = math.floor(window_h)
                            local center_x = (screen_w - window_w) / 2
                            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                            return {
                                border = "rounded",
                                relative = "editor",
                                row = center_y,
                                col = center_x,
                                width = window_w_int,
                                height = window_h_int,
                            }
                        end,
                    },
                    width = function()
                        return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                    end,
                },
                filters = {
                    dotfiles = false,
                    custom = { "^.DS_Store$", "^node_modules$" },
                },
            })

            -- File explorer
            vim.keymap.set(
                "n",
                "<leader>o",
                "<cmd>NvimTreeFindFileToggle<cr>",
                { desc = "Toggle NvimTree (reveal file)" }
            )

            -- Close NvimTree
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "NvimTree",
                callback = function()
                    vim.keymap.set("n", "<Esc>", "<cmd>NvimTreeClose<CR>", { buffer = true, silent = true })
                end,
            })

            -- Find and focus directory
            function find_directory_and_focus()
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")

                local function open_nvim_tree(prompt_bufnr, _)
                    actions.select_default:replace(function()
                        local api = require("nvim-tree.api")

                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        api.tree.open()
                        api.tree.find_file(selection.cwd .. "/" .. selection.value)
                    end)
                    return true
                end

                require("telescope.builtin").find_files({
                    find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
                    attach_mappings = open_nvim_tree,
                })
            end
            vim.keymap.set("n", "<leader>ds", find_directory_and_focus)
        end,
    },
}
