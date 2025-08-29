-- Change accept to shift+tab so I can use tab
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<S-Tab>", 'copilot#Accept("<CR>")', {
  expr = true,
  silent = true,
  noremap = true,
  replace_keycodes = false
})

-- Keybinding to disable Copilot
vim.keymap.set("n", "<leader>cd", function()
    vim.cmd("Copilot disable")
    print("Copilot disabled")
end, { desc = "Disable Copilot" })

-- Keybinding to enable Copilot
vim.keymap.set("n", "<leader>ce", function()
    vim.cmd("Copilot enable")
    print("Copilot enabled")
end, { desc = "Enable Copilot" })


-- Disable Copilot when entering .txt files
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.txt",
    callback = function()
        vim.cmd("Copilot disable")
        print("Copilot disabled")
    end,
})

-- Re-enable Copilot when leaving .txt files
vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "*.txt",
    callback = function()
        vim.cmd("Copilot enable")
        print("Copilot re-enabled")
    end,
})
