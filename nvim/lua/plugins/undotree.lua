return {
    "mbbill/undotree",
    event = "VeryLazy",
    config = function()
        if vim.fn.has("persistent_undo") == 1 then
            local target_path = vim.fn.expand("~/.config/nvim/.undodir")
            vim.opt.undodir = target_path
            vim.opt.undofile = true
            vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
        end
    end,
}
