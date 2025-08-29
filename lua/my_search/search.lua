local M = {}
local CONFIG = require("my_search.config")

local function diagnostic_search()
    return function(render)
        local results = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            for _, diag in ipairs(vim.diagnostic.get(buf)) do
                local filename = vim.api.nvim_buf_get_name(buf)
                local line_num = diag.lnum + 1
                local col_num = diag.col + 1
                local message = diag.message:gsub("\n", " ")
                table.insert(results, string.format("%s:%d:%d:%s", filename, line_num, col_num, message))
            end
        end
        render(results, nil)
    end
end

function M.search(query, render, mode)

    if mode == "errors" then
        local diag_render = diagnostic_search()
        diag_render(render)
        return
    end

    local cmd = CONFIG.derive_cmd(query, mode)
    if cmd == "" then
        render({}, nil)
        return
    end

    local job_id = vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data, _)
            local results = {}
            if data then
                local count = 0
                for _, line in ipairs(data) do
                    if line ~= "" then
                        table.insert(results, line)
                        count = count + 1
                        if count > 50 then
                            break
                        end
                    end
                end
            end
            render(results, nil, query)
        end,
        on_stderr = function(_, err, _)
            local error_msg = nil
            if err and type(err) == "table" then
                for _, line in ipairs(err) do
                    if line ~= "" then
                        error_msg = error_msg and (error_msg .. "; " .. line) or line
                    end
                end
            end
            if error_msg then
                render({}, error_msg)
            end
        end,
        on_exit = function()
            -- Ensure job cleanup if needed
        end,
    })

    if job_id == 0 then
        render({}, "Failed to start rg")
    elseif job_id == -1 then
        render({}, "rg command not executable")
    end
end

return M
