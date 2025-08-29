return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            modules = {}, -- optional, safe to leave empty
            sync_install = false,
            auto_install = true,
            ensure_installed = {}, -- empty means no auto-installs
            ignore_install = {},
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
