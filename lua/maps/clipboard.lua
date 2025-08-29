vim.g.clipboard = {
  name = "xclip",
  copy = {
    ["+"] = "xclip -selection clipboard",
    ["*"] = "xclip -selection primary",
  },
  paste = {
    ["+"] = "xclip -selection clipboard -o",
    ["*"] = "xclip -selection primary -o",
  },
}
 -- Yank to system clipboard
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, silent = true })

 -- Paste from system clipboard
vim.keymap.set('v', '<leader>p', '"+p', { noremap = true, silent = true })
