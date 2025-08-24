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
            keymap = {
                builtin = {
                    ["<F1>"] = "toggle-help",
                    ["<F2>"] = "toggle-fullscreen",
                    ["<F3>"] = "toggle-preview-wrap",
                    ["<C-p>"] = "toggle-preview",
                    ["<F5>"] = "toggle-preview-ccw",
                    ["<F6>"] = "toggle-preview-cw",
                    ["<S-down>"] = "preview-page-down",
                    ["<S-up>"] = "preview-page-up",
                    ["<S-left>"] = "preview-page-reset",
                },
                fzf = {
                    ["ctrl-z"] = "abort",
                    ["ctrl-d"] = "half-page-down",
                    ["ctrl-u"] = "half-page-up",
                    ["ctrl-a"] = "beginning-of-line",
                    ["ctrl-e"] = "end-of-line",
                    ["alt-a"] = "toggle-all",
                    ["ctrl-p"] = "toggle-preview",
                    ["shift-down"] = "preview-page-down",
                    ["shift-up"] = "preview-page-up",
                },
            },
            fzf_opts = {
                ["--ansi"] = "",
                ["--info"] = "inline",
                ["--height"] = "100%",
                ["--layout"] = "default",
                ["--border"] = "none",
            },

            files = {
                prompt = "Files❯ ",
                multiprocess = true,
                git_icons = true,
                file_icons = true,
                color_icons = true,
                find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
                rg_opts = "--color=never --files --hidden --follow -g '!.git'",
                fd_opts = "--color=never --type f --hidden --follow --exclude .git",
            },
            grep = {
                prompt = "Rg❯ ",
                input_prompt = "Grep For❯ ",
                multiprocess = true,
                git_icons = false,
                file_icons = true,
                color_icons = true,
                rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
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
        end, { desc = "Find files (clean search, exclude dist/node_modules/etc)" })

        vim.keymap.set("n", "<leader>ff", function()
            require("fzf-lua").lgrep_curbuf({
                winopts = {
                    preview = {
                        hidden = false, -- show preview for this picker
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
        end, { desc = "Live grep (literal search, exclude junk)" })

        vim.keymap.set("v", "<leader>fsf", function()
            local bufnr = vim.api.nvim_get_current_buf()
            local start_pos = vim.api.nvim_buf_get_mark(bufnr, "<")
            local end_pos = vim.api.nvim_buf_get_mark(bufnr, ">")
            local lines = vim.api.nvim_buf_get_lines(bufnr, start_pos[1] - 1, end_pos[1], false)
            if #lines == 0 then
                return
            end
            lines[#lines] = string.sub(lines[#lines], 1, end_pos[2])
            lines[1] = string.sub(lines[1], start_pos[2] + 1)
            local selection = table.concat(lines, " "):gsub("\n", " ")

            require("fzf-lua").lgrep_curbuf({
                search = selection,
                winopts = { preview = { hidden = false } },
            })
        end, { desc = "Fuzzy search for selection (current buffer)" })

        vim.keymap.set("v", "<leader>fsg", function()
            local bufnr = vim.api.nvim_get_current_buf()
            local start_pos = vim.api.nvim_buf_get_mark(bufnr, "<")
            local end_pos = vim.api.nvim_buf_get_mark(bufnr, ">")
            local lines = vim.api.nvim_buf_get_lines(bufnr, start_pos[1] - 1, end_pos[1], false)
            if #lines == 0 then
                return
            end
            lines[#lines] = string.sub(lines[#lines], 1, end_pos[2])
            lines[1] = string.sub(lines[1], start_pos[2] + 1)
            local selection = table.concat(lines, " "):gsub("\n", " ")

            require("fzf-lua").live_grep({
                search = selection,
                winopts = { preview = { hidden = false } },
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
        end, { desc = "Find files in user directory" })

        vim.keymap.set("n", "<leader>fdg", function()
            local dir = vim.fn.input("grep directory: ")
            vim.cmd("redraw")
            if dir ~= "" then
                fzf_lua.live_grep({
                    cwd = dir,
                })
            end
        end, { desc = "live grep in user directory" })

        vim.keymap.set("v", "<leader>fds", function()
            local bufnr = vim.api.nvim_get_current_buf()
            local start_pos = vim.api.nvim_buf_get_mark(bufnr, "<")
            local end_pos = vim.api.nvim_buf_get_mark(bufnr, ">")
            local lines = vim.api.nvim_buf_get_lines(bufnr, start_pos[1] - 1, end_pos[1], false)
            if #lines == 0 then
                return
            end
            lines[#lines] = string.sub(lines[#lines], 1, end_pos[2])
            lines[1] = string.sub(lines[1], start_pos[2] + 1)
            local selection = table.concat(lines, " "):gsub("\n", " ")

            local dir = vim.fn.input("grep directory: ")
            vim.cmd("redraw")
            if dir ~= "" then
                require("fzf-lua").live_grep({
                    cwd = dir,
                    search = selection,
                    winopts = { preview = { hidden = false } },
                })
            end
        end, { desc = "Live grep for selection in user directory" })
    end,
}
