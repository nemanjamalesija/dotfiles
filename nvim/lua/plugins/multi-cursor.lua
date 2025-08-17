return {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
        vim.g.VM_maps = {
            ["Add Cursor Down"] = "<c-j>",
            ["Add Cursor Up"] = "<c-k>",
        }
    end,
}
