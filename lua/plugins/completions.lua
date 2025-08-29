return {
	{ "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-cmdline" },
	{ "github/copilot.vim" },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                "~/.config/nvim/lua",
            }
        }
    },
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			vim.api.nvim_set_hl(0, "MyFloatNormal", { bg = "#1E1E1E", fg = "#FFFFFF" })
			vim.api.nvim_set_hl(0, "MyCursorLine", { bg = "#404040" })
			vim.api.nvim_set_hl(0, "MyFloatBorder", { bg = "#1E1E1E", fg = "#569CD6" })
			local window = cmp.config.window.bordered()
			window.max_width = 50
			window.winhighlight = "Normal:MyFloatNormal,FloatBorder:MyFloatBorder,CursorLine:MyCursorLine,Search:None"
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = window,
					documentation = window,
				},
                formatting = {
                    format = function(_, vim_item)
                        -- Truncate abbr (main completion text)
                        if vim_item.abbr and #vim_item.abbr > 32 then
                            vim_item.abbr = string.sub(vim_item.abbr, 1, 32) .. "..."
                        end
                        -- Truncate menu (right-side description)
                        local m = vim_item.menu and vim_item.menu or ""
                        if #m > 32 then
                            vim_item.menu = string.sub(m, 1, 32) .. "..."
                        end
                        return vim_item
                    end,
                },
				mapping = cmp.mapping.preset.insert({
					["<A-j>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i" }),
					["<A-k>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i" }),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For luasnip users.
				}, {
					{ name = "buffer" },
				}),
			})
			-- `/` cmdline setup.
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- `:` cmdline setup.
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = {
                    disallow_symbol_nonprefix_matching = false,
                    disallow_fullfuzzy_matching = false,
                    disallow_fuzzy_matching = false,
                    disallow_partial_fuzzy_matching = false,
                    disallow_partial_matching = false,
                    disallow_prefix_unmatching = false,
                },
			})

			-- bright white for normal text
			vim.api.nvim_set_hl(0, "CmpItemAbbr", { bg = "NONE", fg = "#FFFFFF" })
			-- gray
			vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = "#808080" })
			-- blue
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#4A90E2" })
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })
			-- light blue
			vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = "#9CDCFE" })
			vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })
			vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
			-- pink
			vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = "#C586C0" })
			vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })
			-- front
			vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = "#D4D4D4" })
			vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindKeyword" })
			vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })
		end,
	},
}
