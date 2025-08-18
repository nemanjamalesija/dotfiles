return {
    "nvim-zh/colorful-winsep.nvim",
    event = { "WinLeave" },
    config = function()
        local opts = {
            border = "bold",
        }
        require("colorful-winsep").setup(opts)
    end,
}
