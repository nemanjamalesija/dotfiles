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
                    vertical = "up:80%",
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
                    ["ctrl-u"] = "unix-line-discard",
                    ["ctrl-f"] = "half-page-down",
                    ["ctrl-b"] = "half-page-up",
                    ["ctrl-a"] = "beginning-of-line",
                    ["ctrl-e"] = "end-of-line",
                    ["alt-a"] = "toggle-all",
                    ["f3"] = "toggle-preview-wrap",
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

        -- Live grep with exclusions
        vim.keymap.set("n", "<leader>F", function()
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

        -- Fuzzy search in current buffer
        vim.keymap.set("n", "<leader>f", function()
            require("fzf-lua").lgrep_curbuf({
                winopts = {
                    preview = {
                        hidden = false, -- show preview for this picker
                    },
                },
            })
        end, { desc = "Fuzzy search in current buffer" })

        -- Live grep in specific directory
        vim.keymap.set("n", "<leader>fd", function()
            local dir = vim.fn.input("grep directory: ")
            vim.cmd("redraw")
            if dir ~= "" then
                fzf_lua.live_grep({
                    cwd = dir,
                })
            end
        end, { desc = "live grep in user directory" })
    end,
}
