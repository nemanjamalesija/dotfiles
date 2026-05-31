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

        -- Jump to the next / previous occurrence of the word under the cursor
        -- using Vim's own search engine -- the same one * # n N use -- so it
        -- behaves identically: whole-word, works from anywhere inside the word,
        -- and always wraps around the file. Nothing is left highlighted and the
        -- user's last search (the / register and 'hlsearch' state) is restored.
        local function jump_to_reference(direction)
            if vim.fn.expand("<cword>") == "" then
                return
            end
            local save_search = vim.fn.getreg("/")
            local save_hlsearch = vim.v.hlsearch
            local save_wrapscan = vim.o.wrapscan
            vim.o.wrapscan = true -- always loop around the file
            -- '*' = next whole-word match, '#' = previous
            vim.cmd("silent! normal! " .. (direction == "next" and "*" or "#"))
            vim.o.wrapscan = save_wrapscan
            vim.fn.setreg("/", save_search)
            vim.v.hlsearch = save_hlsearch
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

        -- Re-apply on every FileType so these win over the buffer-local [[ / ]]
        -- maps that many ftplugins (python, ruby, rust, go, php, ...) install.
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(ev)
                map("]]", "next", ev.buf)
                map("[[", "prev", ev.buf)
            end,
        })

        -- The plugin loads after the first file's FileType has already fired,
        -- so cover buffers that are open by the time we get here.
        for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buffer) then
                map("]]", "next", buffer)
                map("[[", "prev", buffer)
            end
        end

        -- Light theme: override everforest's bold-only IlluminatedWord with a magenta underline.
        -- Dark theme: leave vscode.nvim's default background highlight in place.
        if vim.g.theme_mode == "light" then
            local function set_illuminate_highlights()
                for _, group in ipairs({
                    "IlluminatedWordText",
                    "IlluminatedWordRead",
                    "IlluminatedWordWrite",
                    "LspReferenceText",
                    "LspReferenceRead",
                    "LspReferenceWrite",
                }) do
                    vim.api.nvim_set_hl(0, group, { underline = true, sp = 0xbf68d9 })
                end
            end
            set_illuminate_highlights()
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                callback = set_illuminate_highlights,
            })
        end
    end,
    keys = {
        { "]]", desc = "Next Reference" },
        { "[[", desc = "Prev Reference" },
    },
}
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
--             local word = vim.fn.expand("<cword>")
--             if word == "" or word:match("^%s*$") then
--                 return
--             end
--             local pattern = "\\<" .. vim.fn.escape(word, "\\") .. "\\>"
--             local flags = direction == "next" and "W" or "bW"
--             local pos = vim.fn.searchpos(pattern, flags)
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
--         local function set_illuminate_highlights()
--             local label_bg = "#EFEBD4"
--             local blend = 60
--
--             for _, group in ipairs({
--                 "IlluminatedWordText",
--                 "IlluminatedWordRead",
--                 "IlluminatedWordWrite",
--                 "LspReferenceText",
--                 "LspReferenceRead",
--                 "LspReferenceWrite",
--             }) do
--                 vim.api.nvim_set_hl(0, group, {
--                     bg = label_bg, -- set background color
--                     fg = nil, -- use default foreground
--                     bold = false, -- disable bold
--                     underline = false, -- disable underline
--                     -- blend = blend,
--                 })
--             end
--         end
--
--         -- Always set highlights after colorscheme loads!
--         vim.api.nvim_create_autocmd("ColorScheme", {
--             pattern = "*",
--             callback = set_illuminate_highlights,
--         })
--         set_illuminate_highlights()
--     end,
--     keys = {
--         { "]]", desc = "Next Reference" },
--         { "[[", desc = "Prev Reference" },
--     },
-- }
