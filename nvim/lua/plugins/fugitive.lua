return {
  "tpope/vim-fugitive",
  event = "VeryLazy",
  config = function()
    vim.g.fugitive_diff_tool = "sublimemerge"
    vim.opt.diffopt:append("vertical")
    vim.keymap.set("n", "<leader>gs", ":Git status<CR>", { desc = "Git Status" })
    vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git Blame" })
    -- Open Sublime Merge
    vim.keymap.set(
      "n",
      "<leader>gt",
      ":silent !smerge<CR>",
      { desc = "Open Sublime Merge", noremap = true, silent = true }
    )

    vim.cmd([[
      cabbrev git Git
    ]])
  end,
}
