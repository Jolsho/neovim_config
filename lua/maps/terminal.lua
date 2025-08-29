-- open terminal in normal mode
vim.keymap.set('n', '<leader>tt', ':split | term<CR>i', { noremap = true, silent = true })
-- exit terminal insert mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- special terminal commands for projects
vim.keymap.set('n', '<leader>tg', ':split | term cd ~/TUIE/server && go build -o server && ./server<CR>i', { noremap = true, silent = true })
