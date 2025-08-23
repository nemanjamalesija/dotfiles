return {
    "MagicDuck/grug-far.nvim",
    config = function()
        require("grug-far").setup({})
    end,
    keys = {
        {
            "<leader>srg",
            function()
                require("grug-far").open() -- No paths: project/global search
            end,
            mode = { "n", "v" },
            desc = "Search and Replace (Global/Project)",
        },
        {
            "<leader>srf",
            function()
                local grug = require("grug-far")
                local buffer = vim.fn.expand("%")
                grug.open({
                    transient = true,
                    prefills = { paths = buffer },
                })
            end,
            mode = { "n", "v" },
            desc = "Search and Replace (Current Buffer)",
        },
    },
}
