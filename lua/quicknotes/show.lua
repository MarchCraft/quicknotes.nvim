local M = {}
local popup = require("plenary.popup")

function M.MyMenu()
    local filelocation = vim.fn.expand("~/.quicknotes")
    local data = fetchQuicknotesFromFile(filelocation)
    ShowMenu(data)
end

function ShowMenu(opts, cb)
    local height = 20
    local width = 50
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    Win_id = popup.create(opts, {
        title = "QuickNotes",
        highlight = "MyProjectWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        callback = cb,
    })
    local bufnr = vim.api.nvim_win_get_buf(Win_id)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent=false })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "w", "<cmd>lua WriteMenu()<CR>", { silent=false })


end

function fetchQuicknotesFromFile(filelocation)
    local file = io.open(filelocation, "r")
    local data = {}
    for line in file:lines() do
        table.insert(data, line)
    end
    return data
end

function CloseMenu()
    vim.api.nvim_win_close(Win_id, true)
end

function WriteMenu()
    local filelocation = vim.fn.expand("~/.quicknotes")
    local bufnr = vim.api.nvim_win_get_buf(Win_id)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local file = io.open(filelocation, "w")
    for _, line in ipairs(lines) do
            file:write(line.."\n")
    end
    file:close()
    CloseMenu()
end


return M

