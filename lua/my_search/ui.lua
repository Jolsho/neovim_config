local M = {}

-- Cleanup function
function M.cleanup(input, result)
    -- Delete autocommand groups
    pcall(vim.api.nvim_del_augroup_by_name, "SearchPluginHighlights")
    pcall(vim.api.nvim_del_augroup_by_name, "SearchPluginModeSwitch")
    pcall(vim.api.nvim_del_augroup_by_name, "SearchInput")

    -- Clear namespace
    pcall(vim.api.nvim_buf_clear_namespace, result.buf, result.ns_id, 0, -1)

    -- Delete key mappings
    pcall(vim.api.nvim_buf_del_keymap, input.buf, "i", "<Esc>")
    pcall(vim.api.nvim_buf_del_keymap, result.buf, "n", "<Enter>")
    pcall(vim.api.nvim_buf_del_keymap, result.buf, "n", "<Esc>")

    -- Close windows
    if vim.api.nvim_win_is_valid(input.win) then
        pcall(vim.api.nvim_win_close, input.win, true)
    end
    if vim.api.nvim_win_is_valid(result.win) then
        pcall(vim.api.nvim_win_close, result.win, true)
    end

    -- Delete buffers
    if vim.api.nvim_buf_is_valid(input.buf) then
        pcall(vim.api.nvim_buf_delete, input.buf, { force = true })
    end
    if vim.api.nvim_buf_is_valid(result.buf) then
        pcall(vim.api.nvim_buf_delete, result.buf, { force = true })
    end
end


function M.create_windows()
    -----------------------------------------
    --- INPUT
    -----------------------------------------
    local input_buf = vim.api.nvim_create_buf(false,true)
    local input_win = vim.api.nvim_open_win(input_buf, true, {
        relative = "editor",
        width = 80,
        height = 1,
        row = 7,
        col = 20,
        style = "minimal",
        border = "single",
    })

    -- Buffer options for input
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = input_buf })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = input_buf })
    vim.api.nvim_set_option_value("modifiable", true, { buf = input_buf })

    -----------------------------------------
    --- RESULTS
    -----------------------------------------
    local results_buf = vim.api.nvim_create_buf(false, true) -- Scratch buffer, not listed
    local results_win = vim.api.nvim_open_win(results_buf, true, {
        relative = "editor",
        width = 80,
        height = 20,
        row = 10,
        col = 20,
        style = "minimal",
        border = "single",
    })

    -- Buffer options to optimize for search input and results
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = results_buf }) -- No file association
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = results_buf }) -- Wipe buffer when hidden
    vim.api.nvim_set_option_value("modifiable", true, { buf = results_buf }) -- Ensure buffer is not modifiable

    -- Window options (fix for 'wrap')
    vim.wo[results_win].wrap = false -- Set window-local option 'wrap' using vim.wo

    -- Enable cursorline for the current window
    vim.api.nvim_set_option_value("cursorline", true, { scope = "local" })

    -- Optional: Define a highlight group for dynamic cursor line highlighting
    vim.api.nvim_set_hl(0, "MySearchCursorLine", { bg = "#4a4a4a", bold = true })

    local ns_id = vim.api.nvim_create_namespace("my_search_cursor_line")
    -- Create an autocommand group for cursor movement highlights
    local group = vim.api.nvim_create_augroup("SearchPluginHighlights", { clear = true })
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = results_buf,
        callback = function()
            -- Clear previous highlights
            vim.api.nvim_buf_clear_namespace(results_buf, ns_id, 0, -1)
            -- Get current line number
            local lnum = vim.api.nvim_win_get_cursor(0)[1]
            -- Apply highlight to the current line using extmark
            vim.api.nvim_buf_set_extmark(results_buf, ns_id, lnum, 0, {
                hl_group = "MySearchCursorLine",
                hl_eol = true,
                right_gravity = false,
            })
        end,
    })

    -----------------------------------------
    --- BOTH
    -----------------------------------------
    local results = { buf = results_buf, win = results_win, ns_id = ns_id }
    local input = { buf = input_buf, win = input_win }

    -- Ensure focus on input window and enter insert mode
    vim.api.nvim_set_current_win(input.win)
    local line_content = vim.api.nvim_buf_get_lines(input.buf, 0, 1, false)[1]
    local col = #line_content -- Get the length of the line content
    vim.api.nvim_win_set_cursor(input.win, { 1, col })
    vim.cmd("startinsert")

    -- Autocommand group for mode switching
    local mode_group = vim.api.nvim_create_augroup("SearchPluginModeSwitch", { clear = true })

    -- Switch to input window when entering insert mode
    vim.api.nvim_create_autocmd("InsertEnter", {
        group = mode_group,
        callback = function()
            vim.api.nvim_set_current_win(input.win)
            local line = vim.api.nvim_buf_get_lines(input.buf, 0, 1, false)[1] or ""
            vim.api.nvim_win_set_cursor(input.win, {1, #line})
            vim.cmd("startinsert!") -- Ensure append mode (cursor after last character)
        end,
    })

    -- Switch to results window when entering normal mode
    vim.api.nvim_create_autocmd("InsertLeave", {
        group = mode_group,
        callback = function()
            vim.api.nvim_set_current_win(results.win)
            vim.api.nvim_win_set_cursor(results.win, {1, 0})
        end,
    })

    -- Create autocommand to trigger cleanup when leaving the plugin windows
    vim.api.nvim_create_autocmd("WinLeave", {
        group = vim.api.nvim_create_augroup("SearchPluginCleanup", { clear = true }),
        buffer = input.buf,
        callback = function()
            M.cleanup(input, results)
        end,
        once = true, -- Run only once to avoid redundant cleanup
    })
    vim.api.nvim_create_autocmd("WinLeave", {
        group = vim.api.nvim_create_augroup("SearchPluginCleanup", { clear = true }),
        buffer = results.buf,
        callback = function()
            M.cleanup(input, results)
        end,
        once = true, -- Run only once to avoid redundant cleanup
    })

    -- Close windows with <Esc> in normal mode
    vim.keymap.set("i", "<Esc>", function()
        M.cleanup(input, results)
    end, { buffer = input.buf })
    vim.keymap.set("n", "<Esc>", function()
        M.cleanup(input, results)
    end, { buffer = results.buf })

    return results, input
end

local ns = vim.api.nvim_create_namespace("my_search_highlight")

function M.render(buf, results, error, query)
    local display = {}

    if error then
        table.insert(display, "Error: " .. error)
    elseif #results == 0 then
        table.insert(display, "No results")
    else
        for _, line in ipairs(results) do
            table.insert(display, line)
        end
    end

    -- Clear old lines and set new ones
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, display)

    -- Clear previous highlights *from our namespace only*
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

    if query and query ~= "" then
        local hl_group = "MySearchMatch" -- custom group
        local query_lower = query:lower()

        for linenr, line in ipairs(display) do
            local line_lower = line:lower()
            local start_idx = 1

            while start_idx <= #line_lower do
                local s, e = line_lower:find(query_lower, start_idx, true)
                if not s then break end

                -- Highlight each character individually
                for i = s, e do
                    vim.api.nvim_buf_set_extmark(buf, ns, linenr - 1, i - 1, {
                        end_col = i,
                        hl_group = hl_group,
                        hl_mode = "combine", -- combine with existing highlights
                    })
                end

                start_idx = s + 1
            end
        end
    end
end
return M
