-- Helper functions for code quality indicators
local function trailing_space()
    if not vim.o.modifiable then
        return ""
    end

    for i = 1, vim.fn.line("$") do
        local linetext = vim.fn.getline(i)
        local idx = vim.fn.match(linetext, [[\v\s+$]])
        if idx ~= -1 then
            return string.format("[%d]trailing", i)
        end
    end
    return ""
end

local function mixed_indent()
    if not vim.o.modifiable then
        return ""
    end

    local space_pat = [[\v^ +]]
    local tab_pat = [[\v^\t+]]
    local space_indent = vim.fn.search(space_pat, "nwc")
    local tab_indent = vim.fn.search(tab_pat, "nwc")
    local mixed = (space_indent > 0 and tab_indent > 0)
    local mixed_same_line

    if not mixed then
        mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], "nwc")
        mixed = mixed_same_line > 0
    end

    if not mixed then
        return ""
    end

    if mixed_same_line ~= nil and mixed_same_line > 0 then
        return "MI:" .. mixed_same_line
    end

    local space_indent_cnt = vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
    local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total

    if space_indent_cnt > tab_indent_cnt then
        return "MI:" .. tab_indent
    else
        return "MI:" .. space_indent
    end
end

local function get_active_lsp()
    local msg = "🚫"
    local buf_ft = vim.api.nvim_get_option_value("filetype", {})
    local clients = vim.lsp.get_clients({ bufnr = 0 })

    if next(clients) == nil then
        return msg
    end

    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
        end
    end
    return msg
end

local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function(_, opts)
        opts.options = {
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            globalstatus = true,
            refresh = {
                statusline = 1000,
            },
        }

        opts.sections = {
            lualine_a = { "mode" },
            lualine_b = {
                {
                    "filename",
                    --branch
                    -- icon = "",
                    color = { gui = "bold" },
                    file_status = true,
                    path = 1,
                    symbols = {
                        modified = "[+]",
                        readonly = " ",
                        unnamed = "[No Name]",
                        newfile = "[New]",
                    },
                },
            },
            lualine_c = {
                {
                    "diff",
                    source = diff_source,
                },
            },
            lualine_x = {
                {
                    get_active_lsp,
                },
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic", "coc" },
                    sections = { "error", "warn", "info", "hint" },
                    diagnostics_color = {
                        error = "DiagnosticError",
                        warn = "DiagnosticWarn",
                        info = "DiagnosticInfo",
                        hint = "DiagnosticHint",
                    },
                    symbols = { error = "E", warn = "W", info = "I", hint = "H" },
                    colored = true,
                    update_in_insert = false,
                    always_visible = false,
                },
                {
                    trailing_space,
                    color = "WarningMsg",
                },
                {
                    mixed_indent,
                    color = "WarningMsg",
                },
            },
            lualine_y = {
                "progress",
            },
            lualine_z = {
                -- function()
                --     return os.date("%H:%M")
                -- end,
            },
        }

        opts.inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        }

        if not vim.g.trouble_lualine then
            table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
        end
    end,
}
