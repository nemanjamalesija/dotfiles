return {
    "ibhagwan/fzf-lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-tree/nvim-tree.lua",
    },
    config = function()
        local fzf_lua = require("fzf-lua")

        fzf_lua.setup({
            winopts = {
                width = 0.8,
                height = 0.8,
                row = 0.5,
                col = 0.5,
                border = "rounded",
                preview = {
                    border = "border",
                    wrap = "nowrap",
                    hidden = true,
                    layout = "vertical",
                    vertical = "up:75%",
                },
            },
        })

        -- Helper function to create excluded directories for fd
        local function get_fd_exclude_args()
            local excludes = {
                "__install",
                "__project",
                "_db_diff",
                "_cache",
                "public/dist",
                "_local_cache",
                "node_modules",
                "migrations",
                "logs",
                "var/translations-cache",
                "symfony/var/cache",
                "var/minimalna-dumps",
                "data/dynamic_ad",
                "app/config/category",
                "data/dynamic_ad_repo",
                "tests",
                "dist",
                "ssr-dist",
                ".git",
                "var/cache/dev",
            }

            local args = "--type f --hidden --follow --color=never"
            for _, exclude in ipairs(excludes) do
                args = args .. " --exclude " .. exclude
            end
            return args
        end

        -- Helper function to create rg glob patterns for exclusions
        local function get_rg_exclude_globs()
            local excludes = {
                "__install",
                "__project",
                "_db_diff",
                "_cache",
                "public/dist",
                "_local_cache",
                "node_modules",
                "migrations",
                "logs",
                "symfony/var/cache",
                "var/minimalna-dumps",
                "data/dynamic_ad",
                "app/config/category",
                "data/dynamic_ad_repo",
                "tests",
                "dist",
                "ssr-dist",
                "var/translations-cache",
                ".git/logs",
                "var/cache/dev",
            }

            local globs = {}
            for _, exclude in ipairs(excludes) do
                table.insert(globs, "--glob")
                table.insert(globs, "!**/" .. exclude .. "/**")
            end
            return globs
        end

        -- Keymaps
        vim.keymap.set("n", "<leader><leader>", function()
            fzf_lua.files({
                fd_opts = get_fd_exclude_args(),
                cwd_prompt = false,
                cwd_header = true,
            })
        end, { desc = "Find files" })

        vim.keymap.set("n", "<leader>ff", function()
            require("fzf-lua").lgrep_curbuf({
                winopts = {
                    preview = {
                        hidden = false,
                    },
                },
            })
        end, { desc = "Fuzzy search in current buffer" })

        vim.keymap.set("n", "<leader>fg", function()
            local rg_opts = "--column --line-number --no-heading --color=always --hidden --no-ignore --fixed-strings"
            local exclude_globs = get_rg_exclude_globs()

            -- Convert globs table to string
            local globs_str = ""
            for i = 1, #exclude_globs, 2 do
                globs_str = globs_str .. " " .. exclude_globs[i] .. " '" .. exclude_globs[i + 1] .. "'"
            end

            fzf_lua.live_grep({
                rg_opts = rg_opts .. globs_str,
                exec_empty_query = true,
                winopts = {
                    preview = {
                        hidden = false, -- show preview for this picker
                    },
                },
            })
        end, { desc = "Live grep (project wide)" })

        vim.keymap.set("v", "<leader>fsf", function()
            -- Yank current selection to unnamed register
            vim.cmd("normal! y")
            local selection = vim.fn.getreg('"')

            -- Clean up the selection
            selection = selection:gsub("\n", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

            if selection == "" then
                return
            end

            require("fzf-lua").lgrep_curbuf({
                search = selection,
                winopts = {
                    preview = { hidden = false },
                },
            })
        end, { desc = "Fuzzy search for selection in the current file" })

        vim.keymap.set("v", "<leader>fsg", function()
            vim.cmd("normal! y")
            local selection = vim.fn.getreg('"')

            selection = selection:gsub("\n", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

            if selection == "" then
                return
            end

            require("fzf-lua").live_grep({
                search = selection,
                winopts = {
                    preview = { hidden = false },
                },
            })
        end, { desc = "Live grep for selection (project-wide)" })

        vim.keymap.set("n", "<leader>fdf", function()
            local dir = vim.fn.input("files directory: ")
            vim.cmd("redraw")
            if dir ~= "" then
                require("fzf-lua").files({
                    cwd = dir,
                })
            end
        end, { desc = "Find files in specified directory" })

        vim.keymap.set("n", "<leader>fdg", function()
            local dir = vim.fn.input("grep directory: ")
            vim.cmd("redraw")
            if dir ~= "" then
                fzf_lua.live_grep({
                    cwd = dir,
                    winopts = { preview = { hidden = false } },
                })
            end
        end, { desc = "Live grep in specified directory" })

        vim.keymap.set("n", "<leader>fdbf", function()
            fzf_lua.files({
                cwd = "presentation-backend",
            })
        end, { desc = "Find files in presentation-backend" })

        vim.keymap.set("n", "<leader>fdpbg", function()
            fzf_lua.live_grep({
                cwd = "presentation-backend",
                winopts = { preview = { hidden = false } },
            })
        end, { desc = "Live grep in presentation-backend" })
    end,
}
