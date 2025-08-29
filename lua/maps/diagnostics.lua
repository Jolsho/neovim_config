
-- Define highlights for the floating window
vim.api.nvim_set_hl(0, "MyDiagnosticFloat", { bg = "#1E1E1E", fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, "MyDiagnosticFloatBorder", { bg = "#1E1E1E", fg = "#569CD6" })

-- Show diagnostics with rounded borders and custom highlights
vim.keymap.set("n", "<leader>dl", function()
    vim.diagnostic.open_float({
        border = "rounded",
        scope = "line",
        focusable = true,
        max_width = 60,
        close_events = { "CursorMoved", "FocusLost" },
        winhighlight = "Normal:MyDiagnosticFloat,FloatBorder:MyDiagnosticFloatBorder",
    })
end, {})

-- Go to the next diagnostic
vim.keymap.set("n", "<leader>dn", function()
    vim.diagnostic.jump({
        direction="next",
        count = 1,
    })
end,{})

-- Go to the previous diagnostic
vim.keymap.set("n", "<leader>dp", function()
    vim.diagnostic.jump({
        direction="prev",
        count = 1,
    })
end,{})

-- Show all diagnostics in a quickfix list
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist,{})
