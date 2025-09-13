return {
    {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        config = function()
            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { "indent", "lsp" }
                end,
            })

            vim.keymap.set("n", "zO", require("ufo").openAllFolds)
            vim.keymap.set("n", "zC", require("ufo").closeAllFolds)

            vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter" }, {
                callback = function()
                    local filetype = vim.bo.filetype
                    if filetype ~= "" and vim.bo.buftype == "" then
                        vim.schedule(function()
                            pcall(vim.cmd, "UfoEnableFold")
                        end)
                    end
                end,
            })
        end,
    },
}
