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
                local char = vim.fn.getcharstr()
                if char == "" or char == "\27" then
                    return
                end

                local current_line = vim.fn.line(".")

                Flash.jump({
                    search = {
                        mode = "search",
                        multi_window = false,
                    },
                    jump = { autojump = true },
                    label = { after = false, before = { 0, 0 }, uppercase = false, style = "inline", distance = true },
                    pattern = vim.pesc(char),
                    matcher = function(win)
                        local matches = {}
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
