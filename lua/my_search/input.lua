local M = {}
local UI = require("my_search.ui")

local function to_normal_mode()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "n", false)
end

function M.setup_keys(input, result, update_query, mode)
    -----------------------------------------
    --- RESULTS
    -----------------------------------------
    local res_opts = { buffer = result.buf, nowait = true, noremap = true, silent = true }
    -- Function to open file from the current line
    local function open_file_from_line()
        vim.api.nvim_set_current_win(result.win)
        local line = vim.fn.getline(".") -- Get the current line content

        UI.cleanup(input, result)
        if mode == "files" then
            -- Line is just a filename
            if line and line ~= "" then
                vim.cmd(string.format("edit %s", line))
            end
        else
            -- OR DIAGNOSTICS
            -- Match ripgrep format: "filename:line:col:content"
            local filename, line_num, col_num = line:match("^([^:]+):(%d+):(%d+):")
            if filename and line_num then
                -- Open the file
                vim.cmd(string.format("edit %s", filename))
                -- Jump to line + column (note: column is 0-indexed in Neovim API)
                vim.api.nvim_win_set_cursor(0, { tonumber(line_num), tonumber(col_num or 1) - 1 })
            end
        end
        to_normal_mode()
    end

    -- Keymap to open file on <Enter> in normal mode
    vim.keymap.set("n", "<Enter>", open_file_from_line, res_opts)

    -----------------------------------------
    --- INPUT
    -----------------------------------------
    local in_opts = { buffer = input.buf, nowait = true, noremap = true, silent = true }
    -- Keymap to open file on <Enter> in normal mode
    vim.keymap.set("i", "<Enter>", open_file_from_line, in_opts)

    local input_group = vim.api.nvim_create_augroup("SearchInput", { clear = true })
    -- Autocommand to update query on text change in insert mode
    vim.api.nvim_create_autocmd("TextChangedI", {
        group = input_group,
        buffer = input.buf,
        callback = function()
            local query = vim.fn.getbufline(input.buf, 1)[1]
            if query ~= "" and query ~= " " then
                query = query:gsub("%s+$", "")
                update_query(query)
            end
        end,
    })

    if mode == "errors" then
        update_query(" ")
    end
end

return M
