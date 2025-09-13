local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = {
            colorscheme = "everforest",
        } },
        { import = "lazyvim.plugins.extras.lang.typescript" },
        { import = "lazyvim.plugins.extras.lang.json" },
        { import = "lazyvim.plugins.extras.ui.mini-animate" },
        { import = "lazyvim.plugins.extras.lang.vue" },
        { import = "lazyvim.plugins.extras.coding.luasnip" },
        { import = "lazyvim.plugins.extras.linting.eslint" },
        { import = "lazyvim.plugins.extras.formatting.biome" },
        { import = "lazyvim.plugins.extras.coding.nvim-cmp" },
        { import = "lazyvim.plugins.extras.editor.illuminate" },
        --[[ {
            "github/copilot.vim",
            config = function()
                -- Disable Copilot by default
                vim.cmd("Copilot disable")

                -- Map <C-c> in insert mode to enable Copilot and trigger a suggestion
                vim.api.nvim_set_keymap("i", "<C-c>", "<Cmd>Copilot enable<CR>", { noremap = true, silent = true })

                -- Optional: Disable <Tab> remapping if you previously changed it
                -- vim.g.copilot_no_tab_map = false
            end,
        }, ]]
        { import = "plugins" },
    },
    defaults = {
        lazy = false,
        version = false,
    },
    checker = {
        enabled = true,
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "zipPlugin",
                "tutor",
                "bufferline",
            },
        },
    },
})
