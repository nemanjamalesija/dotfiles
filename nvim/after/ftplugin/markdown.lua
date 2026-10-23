-- Markdown has no language server here, so <leader>gd follows the link under
-- the cursor instead of asking for a definition.

-- GitHub's heading anchors: lowercase, punctuation dropped, spaces as dashes.
local function get_anchor(heading)
    local text = heading:lower():gsub("[^%w%s%-]", "")
    local anchor = text:gsub("%s", "-")
    return anchor
end

local function go_to_heading(anchor)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for number, line in ipairs(lines) do
        local heading = line:match("^#+%s+(.*)")
        if heading and get_anchor(heading) == anchor then
            vim.cmd("normal! m'")
            vim.api.nvim_win_set_cursor(0, { number, 0 })
            return
        end
    end
    vim.notify("No heading for #" .. anchor)
end

local function get_link_destination()
    local node = vim.treesitter.get_node({ ignore_injections = false })
    while node and node:type() ~= "inline_link" do
        node = node:parent()
    end
    if not node then
        return
    end
    for child in node:iter_children() do
        if child:type() == "link_destination" then
            return vim.treesitter.get_node_text(child, 0)
        end
    end
end

local function follow_link()
    local destination = get_link_destination()
    if not destination then
        vim.notify("No link under the cursor")
        return
    end
    if destination:match("^%a+://") then
        vim.ui.open(destination)
        return
    end
    local path, anchor = destination:match("^([^#]*)#?(.*)$")
    if path ~= "" then
        local folder = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
        local file = vim.fs.normalize(vim.fs.joinpath(folder, path))
        vim.cmd.edit(vim.fn.fnameescape(file))
    end
    if anchor ~= "" then
        go_to_heading(anchor)
    end
end

vim.keymap.set("n", "<leader>gd", follow_link, { buffer = true, desc = "Follow link" })
