--[[ Old text                    Command         New text
--------------------------------------------------------------------------------
    surr*ound_words             ysiw)           (surround_words)
    *make strings               ys$"            "make strings"
    remove <b>HTML t*ags</b>    dst             remove HTML tags
    'change quot*es'            cs'"            "change quotes"
    <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    delete(functi*on calls)     dsf             function calls ]]

return {
    "kylechui/nvim-surround",
    version = "^3.0.0",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            keymaps = {
                insert = "<C-g>s",
                insert_line = "<C-g>S",
                normal = "s",
                normal_cur = "sl",
                normal_line = "sS",
                normal_cur_line = "sSS",
                visual = "sv",
                visual_line = "svl",
                delete = "ds",
                change = "cs",
                change_line = "cS",
            },
        })
    end,
}
