
-- Clear search highlighting
vim.keymap.set('n', '<leader>/', ':noh<CR>', { noremap = true, silent = true })

-- Search word under cursor (keep position)
vim.keymap.set('n', '<leader>*', '*N', { noremap = true, silent = true })

-- Search and replace 
vim.keymap.set('n', '<leader>R', ':%s//g<Left><Left>', { noremap = true, silent = true })

-- Search and replace with confirmation
vim.keymap.set('n', '<leader>rc', ':%s//gc<Left><Left><Left>', { noremap = true, silent = true })

