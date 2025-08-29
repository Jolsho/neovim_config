return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
            ensure_installed = { "gopls", "rust_analyzer", "lua_ls" }, -- Explicitly install only these servers
            handlers = {
                -- Default handler for other LSPs (if any)
                function(server_name)
                    if server_name ~= "rust_analyzer" then -- Skip rust_analyzer in default handler
                        require("lspconfig")[server_name].setup({
                            capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        })
                    end
                end,
                ["rust_analyzer"] = function()
                    require("lspconfig").rust_analyzer.setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        settings = {
                            ["rust-analyzer"] = {
                                imports = {
                                    granularity = {
                                        group = "module",
                                    },
                                    prefix = "self",
                                },
                                cargo = {
                                    buildScripts = {
                                        enable = true,
                                    },
                                },
                                procMacro = {
                                    enable = true,
                                },
                            },
                        },
                    })
                end,
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        settings = {
                            Lua = {
                                runtime = {
                                    version = "LuaJIT",
                                    path = vim.split(package.path, ";"),
                                },
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                    checkThirdParty = false,
                                },
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    })
                end,
            }
        },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()

            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover({
                    border = "rounded",  -- options: "single", "double", "rounded", "solid", "shadow"
                    max_width = 80,
                    max_height = 20,
                })
            end, {})
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },
}
