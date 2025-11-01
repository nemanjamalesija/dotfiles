-- return {
--     "RRethy/vim-illuminate",
--     event = "LazyFile",
--     opts = {
--         delay = 200,
--         large_file_cutoff = 2000,
--         large_file_overrides = {
--             providers = { "lsp" },
--         },
--     },
--     config = function(_, opts)
--         require("illuminate").configure(opts)
--
--         Snacks.toggle({
--             name = "Illuminate",
--             get = function()
--                 return not require("illuminate.engine").is_paused()
--             end,
--             set = function(enabled)
--                 local m = require("illuminate")
--                 if enabled then
--                     m.resume()
--                 else
--                     m.pause()
--                 end
--             end,
--         }):map("<leader>ux")
--
--         -- Optimized navigation using vim's built-in search
--         local function jump_to_reference(direction)
--             -- Get word under cursor
--             local word = vim.fn.expand("<cword>")
--             if word == "" or word:match("^%s*$") then
--                 return
--             end
--
--             -- Escape special regex characters and use word boundaries
--             local pattern = "\\<" .. vim.fn.escape(word, "\\") .. "\\>"
--
--             -- Search flags: W = don't wrap, w = wrap around
--             local flags = direction == "next" and "W" or "bW"
--             local pos = vim.fn.searchpos(pattern, flags)
--
--             -- If not found, wrap around
--             if pos[1] == 0 then
--                 flags = direction == "next" and "w" or "bw"
--                 vim.fn.searchpos(pattern, flags)
--             end
--         end
--
--         local function map(key, dir, buffer)
--             vim.keymap.set("n", key, function()
--                 jump_to_reference(dir)
--             end, {
--                 desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference",
--                 buffer = buffer,
--                 silent = true,
--             })
--         end
--
--         map("]]", "next")
--         map("[[", "prev")
--
--         vim.api.nvim_create_autocmd("FileType", {
--             callback = function()
--                 local buffer = vim.api.nvim_get_current_buf()
--                 map("]]", "next", buffer)
--                 map("[[", "prev", buffer)
--             end,
--         })
--
--         local function get_function_fg()
--             local hl = vim.api.nvim_get_hl(0, { name = "Label" })
--             return hl and hl.fg or nil
--         end
--
--         local function set_illuminate_highlights()
--             local underline_color = get_function_fg()
--             for _, group in ipairs({
--                 "IlluminatedWordText",
--                 "IlluminatedWordRead",
--                 "IlluminatedWordWrite",
--                 "LspReferenceText",
--                 "LspReferenceRead",
--                 "LspReferenceWrite",
--             }) do
--                 vim.api.nvim_set_hl(0, group, { underline = true, sp = underline_color })
--             end
--         end
--
--         set_illuminate_highlights()
--         vim.api.nvim_create_autocmd("ColorScheme", {
--             pattern = "*",
--             callback = set_illuminate_highlights,
--         })
--     end,
--     keys = {
--         { "]]", desc = "Next Reference" },
--         { "[[", desc = "Prev Reference" },
--     },
-- }

-- Illuminate with background
-- return {
--     "RRethy/vim-illuminate",
--     event = "LazyFile",
--     opts = {
--         delay = 200,
--         large_file_cutoff = 2000,
--         large_file_overrides = {
--             providers = { "lsp" },
--         },
--     },
--     config = function(_, opts)
--         require("illuminate").configure(opts)
--
--         Snacks.toggle({
--             name = "Illuminate",
--             get = function()
--                 return not require("illuminate.engine").is_paused()
--             end,
--             set = function(enabled)
--                 local m = require("illuminate")
--                 if enabled then
--                     m.resume()
--                 else
--                     m.pause()
--                 end
--             end,
--         }):map("<leader>ux")
--
--         -- Optimized navigation using vim's built-in search
--         local function jump_to_reference(direction)
--             -- Get word under cursor
--             local word = vim.fn.expand("<cword>")
--             if word == "" or word:match("^%s*$") then
--                 return
--             end
--             -- Escape special regex characters and use word boundaries
--             local pattern = "\\<" .. vim.fn.escape(word, "\\") .. "\\>"
--             -- Search flags: W = don't wrap, w = wrap around
--             local flags = direction == "next" and "W" or "bW"
--             local pos = vim.fn.searchpos(pattern, flags)
--             -- If not found, wrap around
--             if pos[1] == 0 then
--                 flags = direction == "next" and "w" or "bw"
--                 vim.fn.searchpos(pattern, flags)
--             end
--         end
--
--         local function map(key, dir, buffer)
--             vim.keymap.set("n", key, function()
--                 jump_to_reference(dir)
--             end, {
--                 desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference",
--                 buffer = buffer,
--                 silent = true,
--             })
--         end
--
--         map("]]", "next")
--         map("[[", "prev")
--
--         vim.api.nvim_create_autocmd("FileType", {
--             callback = function()
--                 local buffer = vim.api.nvim_get_current_buf()
--                 map("]]", "next", buffer)
--                 map("[[", "prev", buffer)
--             end,
--         })
--
--         -- Function to get Label's background color
--         local function get_label_bg()
--             local hl = vim.api.nvim_get_hl(0, { name = "Label" })
--             return hl and hl.bg or nil
--         end
--
--         local function set_illuminate_highlights()
--             local label_bg = get_label_bg()
--             local blend = 70
--             for _, group in ipairs({
--                 "IlluminatedWordText",
--                 "IlluminatedWordRead",
--                 "IlluminatedWordWrite",
--                 "LspReferenceText",
--                 "LspReferenceRead",
--                 "LspReferenceWrite",
--             }) do
--                 if label_bg then
--                     vim.api.nvim_set_hl(0, group, { bg = label_bg, blend = blend })
--                 end
--             end
--         end
--
--         set_illuminate_highlights()
--         vim.api.nvim_create_autocmd("ColorScheme", {
--             pattern = "*",
--             callback = set_illuminate_highlights,
--         })
--     end,
--     keys = {
--         { "]]", desc = "Next Reference" },
--         { "[[", desc = "Prev Reference" },
--     },
-- }
return {
    "RRethy/vim-illuminate",
    event = "LazyFile",
    opts = {
        delay = 200,
        large_file_cutoff = 2000,
        large_file_overrides = {
            providers = { "lsp" },
        },
    },
    config = function(_, opts)
        require("illuminate").configure(opts)

        Snacks.toggle({
            name = "Illuminate",
            get = function()
                return not require("illuminate.engine").is_paused()
            end,
            set = function(enabled)
                local m = require("illuminate")
                if enabled then
                    m.resume()
                else
                    m.pause()
                end
            end,
        }):map("<leader>ux")

        -- Optimized navigation using vim's built-in search
        local function jump_to_reference(direction)
            local word = vim.fn.expand("<cword>")
            if word == "" or word:match("^%s*$") then
                return
            end
            local pattern = "\\<" .. vim.fn.escape(word, "\\") .. "\\>"
            local flags = direction == "next" and "W" or "bW"
            local pos = vim.fn.searchpos(pattern, flags)
            if pos[1] == 0 then
                flags = direction == "next" and "w" or "bw"
                vim.fn.searchpos(pattern, flags)
            end
        end

        local function map(key, dir, buffer)
            vim.keymap.set("n", key, function()
                jump_to_reference(dir)
            end, {
                desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference",
                buffer = buffer,
                silent = true,
            })
        end

        map("]]", "next")
        map("[[", "prev")

        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                local buffer = vim.api.nvim_get_current_buf()
                map("]]", "next", buffer)
                map("[[", "prev", buffer)
            end,
        })

        local function set_illuminate_highlights()
            local label_bg = "#EFEBD4"
            local blend = 60
            for _, group in ipairs({
                "IlluminatedWordText",
                "IlluminatedWordRead",
                "IlluminatedWordWrite",
                "LspReferenceText",
                "LspReferenceRead",
                "LspReferenceWrite",
            }) do
                vim.api.nvim_set_hl(0, group, {
                    bg = label_bg, -- set background color
                    fg = nil, -- use default foreground
                    bold = false, -- disable bold
                    underline = false, -- disable underline
                    blend = blend,
                })
            end
        end

        -- Always set highlights after colorscheme loads!
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_illuminate_highlights,
        })
        set_illuminate_highlights()
    end,
    keys = {
        { "]]", desc = "Next Reference" },
        { "[[", desc = "Prev Reference" },
    },
}
