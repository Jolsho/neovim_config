

-- Vertical split
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { noremap = true, silent = true })

 -- Horizontal split
vim.keymap.set('n', '<leader>sh', ':split<CR>', { noremap = true, silent = true })

 -- Horizontal Resize (+,-)
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { noremap = true, silent = true })

-- Vertical Resize (-,+)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })


-- Move between windows
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>', { noremap = true, silent = true })
