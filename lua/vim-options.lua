vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")


vim.g.mapleader= " "
vim.opt.relativenumber = false
vim.opt.number = true
vim.opt.wrap = false
vim.opt.termguicolors = true

require('maps.clipboard')
require('maps.copilot')
require('maps.diagnostics')
require('maps.search')
require('maps.terminal')
require('maps.windows')

-- Exit insert mode
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
-- Save file
vim.keymap.set('n', '<leader>w', ':w<CR>')
-- Quite
vim.keymap.set('n', '<leader>q', ':q<CR>')

-- pagination
vim.keymap.set('n', '<C-c>', '<C-f>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-f>', '<C-b>', { noremap = true, silent = true })

 -- Indent left and keep selection
vim.keymap.set('v', '<', '<gv', { noremap = true })
 -- Indent right and keep selection
vim.keymap.set('v', '>', '>gv', { noremap = true })

-- GIT STUFF
vim.keymap.set('n', '<leader>+', ':Git add .<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>++', ':Git commit<CR>', { noremap = true, silent = true })
