return {
    "folke/flash.nvim",
    keys = {
        { "s", mode = { "n", "x", "o" }, false },
        { "S", mode = { "n", "x", "o" }, false },
        { "r", mode = { "o" }, false },
        { "R", mode = { "o" }, false },
        { "f", mode = { "o" }, false },
        {
            "f",
            function()
                local Flash = require("flash")
                ---@param opts Flash.Format
                local function format(opts)
                    return {
                        { opts.match.label1, "FlashMatch" },
                        { opts.match.label2, "FlashLabel" },
                    }
                end
                -- Get the character input from user
                local char = vim.fn.getcharstr()
                if char == "" or char == "\27" then -- ESC pressed
                    return
                end

                local current_line = vim.fn.line(".") -- Get current line number

                Flash.jump({
                    timeout = 0,
                    search = {
                        mode = "search",
                        multi_window = false,
                    },
                    label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
                    pattern = vim.pesc(char),
                    matcher = function(win)
                        local matches = {}
                        -- Get all matches in the window
                        local lines = vim.api.nvim_buf_get_lines(
                            vim.api.nvim_win_get_buf(win),
                            current_line - 1,
                            current_line,
                            false
                        )
                        if #lines > 0 then
                            local line = lines[1]
                            local col = 1
                            while true do
                                local start_col = line:find(vim.pesc(char), col)
                                if not start_col then
                                    break
                                end
                                table.insert(matches, {
                                    pos = { current_line, start_col - 1 },
                                    end_pos = { current_line, start_col - 1 + #char },
                                    win = win,
                                    buf = vim.api.nvim_win_get_buf(win),
                                })
                                col = start_col + 1
                            end
                        end
                        return matches
                    end,
                    action = function(match, state)
                        state:hide()
                        Flash.jump({
                            timeout = 0,
                            search = { max_length = 0 },
                            highlight = { matches = false },
                            label = { format = format },
                            matcher = function(win)
                                return vim.tbl_filter(function(m)
                                    return m.label == match.label and m.win == win
                                end, state.results)
                            end,
                            labeler = function(matches)
                                for _, m in ipairs(matches) do
                                    m.label = m.label2
                                end
                            end,
                        })
                    end,
                    labeler = function(matches, state)
                        local labels = state:labels()
                        for m, match in ipairs(matches) do
                            match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                            match.label2 = labels[(m - 1) % #labels + 1]
                            match.label = match.label1
                        end
                    end,
                })
            end,
            mode = { "n", "x" },
            desc = "Flash jump to any character on current line",
        },
    },
    opts = function(_, opts)
        opts.modes = {
            char = { enabled = false },
            search = { enabled = false },
            treesitter = { enabled = false },
        }
        opts.defaults = {
            keymaps = {},
        }
    end,
}
