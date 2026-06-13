return {
    "ibhagwan/fzf-lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-tree/nvim-tree.lua",
    },
    config = function()
        local fzf_lua = require("fzf-lua")

        fzf_lua.setup({
            defaults = {
                keymap = {
                    builtin = {
                        ["<c-p>"] = "toggle-preview",
                    },
                    fzf = {
                        ["ctrl-d"] = "half-page-down",
                        ["ctrl-u"] = "half-page-up",
                    },
                },
            },
            winopts = {
                width = 0.88,
                height = 0.8,
                row = 0.5,
                col = 0.5,
                border = "rounded",
                preview = {
                    border = "border",
                    wrap = "nowrap",
                    hidden = true,
                    layout = "vertical",
                    vertical = "down:75%",
                },
            },
            fzf_opts = {
                ["--layout"] = "reverse",
                ["--bind"] = "ctrl-d:half-page-down,ctrl-u:half-page-up",
            },
            grep = {
                fzf_opts = {
                    ["--layout"] = "reverse",
                },
            },
            lgrep = {
                fzf_opts = {
                    ["--layout"] = "reverse",
                },
            },
        })

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

        local function get_rg_exclude_patterns()
            return {
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
        end

        vim.keymap.set("n", "<leader><leader>", function()
            fzf_lua.files({
                fd_opts = get_fd_exclude_args(),
                cwd_prompt = false,
            })
        end, { desc = "Find files" })

        vim.keymap.set("n", "<leader>ff", function()
            require("fzf-lua").lgrep_curbuf({
                fzf_opts = {
                    ["--layout"] = "reverse",
                },
                winopts = {
                    preview = {
                        hidden = false,
                    },
                },
            })
        end, { desc = "Fuzzy search in current buffer" })

        vim.keymap.set("n", "<leader>fg", function()
            fzf_lua.live_grep({
                rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden",
                file_ignore_patterns = get_rg_exclude_patterns(),
                exec_empty_query = true,
                fzf_opts = {
                    ["--layout"] = "reverse",
                },
                winopts = {
                    preview = {
                        hidden = false,
                    },
                },
            })
        end, { desc = "Live grep (smart search)" })

        -- Literal/fixed-string search mode (for exact string matching, useful for special chars)
        vim.keymap.set("n", "<leader>fG", function()
            fzf_lua.live_grep({
                rg_opts = "--column --line-number --no-heading --color=always --fixed-strings --hidden",
                file_ignore_patterns = get_rg_exclude_patterns(),
                exec_empty_query = true,
                fzf_opts = {
                    ["--layout"] = "reverse",
                },
                winopts = {
                    preview = { hidden = false },
                },
            })
        end, { desc = "Live grep (literal/fixed-string mode)" })

        -- Search ALL files (no exclusions, no gitignore) - last resort when you can't find something
        vim.keymap.set("n", "<leader>fxg", function()
            fzf_lua.live_grep({
                rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore",
                exec_empty_query = true,
                fzf_opts = {
                    ["--layout"] = "reverse",
                },
                winopts = {
                    preview = { hidden = false },
                },
            })
        end, { desc = "Live grep (search EVERYWHERE - no exclusions)" })

        -- Find ALL files (no exclusions) - useful for finding files in excluded directories
        vim.keymap.set("n", "<leader>fx<leader>", function()
            fzf_lua.files({
                fd_opts = "--type f --hidden --follow --color=never --no-ignore",
                cwd_prompt = false,
                fzf_opts = {
                    ["--layout"] = "reverse",
                },
            })
        end, { desc = "Find ALL files (no exclusions)" })

        -- Override LazyVim's <leader>fn "New File" with file finder in node_modules.
        -- Deferred to VeryLazy so we run after LazyVim sets its default mapping.
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            once = true,
            callback = function()
                pcall(vim.keymap.del, "n", "<leader>fn")
                vim.keymap.set("n", "<leader>fn", function()
                    fzf_lua.files({
                        cmd = "fd --type f --hidden --follow --no-ignore --color=never . node_modules",
                        cwd_prompt = false,
                        fzf_opts = { ["--layout"] = "reverse" },
                    })
                end, { desc = "Find files in node_modules" })
            end,
        })

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
                fzf_opts = {
                    ["--layout"] = "reverse",
                },
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
                fzf_opts = {
                    ["--layout"] = "reverse",
                },
                winopts = {
                    preview = { hidden = false },
                },
            })
        end, { desc = "Live grep for selection (project-wide)" })

        -- Project-specific fzf keymaps from machine-local config (gitignored).
        local ok, localcfg = pcall(require, "config.local")
        if ok and type(localcfg) == "table" and localcfg.fzf_keymaps then
            localcfg.fzf_keymaps(fzf_lua)
        end
    end,
}
