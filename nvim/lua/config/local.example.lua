-- Machine-local / work-specific Neovim config.
-- Copy to nvim/lua/config/local.lua (gitignored) and fill in your values.
-- Plugin specs load this via pcall(require, "config.local"), so it's safe to omit.

local M = {}

-- Project-specific fzf keys, in lazy.nvim's keys format.
-- plugins/fzf.lua adds them to its own keys list.
-- M.fzf_keys = {
--     {
--         "<leader>pf",
--         function()
--             require("fzf-lua").files({ cwd = "my-project", fzf_opts = { ["--layout"] = "reverse" } })
--         end,
--         desc = "Find files in my-project",
--     },
-- }

return M
