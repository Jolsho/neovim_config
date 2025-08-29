local M = {}
local UI = require("my_search.ui")
local SEARCH = require("my_search.search")
local INPUT = require("my_search.input")

function M.start_popup(mode)
    -- State
    local result, input = UI.create_windows()

    -- Render function
    local function render(results, error, query)
        UI.render(result.buf, results, error, query)
    end

    -- Search function with debouncing
    local timer = nil
    local function do_search(query)
        if timer then
            vim.fn.timer_stop(timer)
        end
        timer = vim.fn.timer_start(100, function()
            SEARCH.search(query, render, mode)
        end)
    end

    -- Set up keymaps
    INPUT.setup_keys(input, result, do_search, mode)

    -- Initial render
    render({}, nil)
end

-- Setup function: binds your trigger key
function M.setup()
    vim.api.nvim_set_hl(0, "MySearchMatch", { fg = "#fab387", bold = true })

    vim.keymap.set("n", "<leader>bb", function()
        M.start_popup("words")
    end , { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>bf", function()
        M.start_popup("files")
    end , { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>be", function()
        M.start_popup("errors")
    end , { noremap = true, silent = true })
end

return M
