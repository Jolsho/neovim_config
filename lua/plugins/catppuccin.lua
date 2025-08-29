return {
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			transparent_background = false,
			color_overrides = {
				all = {
					crust = "#1E1E1E",
					mantle = "#242424",
				},
			},
			float = {
                transparent = false,
                solid = false,
				enabled = true, -- Enable floating windows
				border = "rounded", -- Choose between 'rounded', 'solid', 'shadow', or 'single'
				blend = 0, -- Set transparency level (0 to 100)
				highlight = "NormalFloat", -- Highlight group for the background
				title = true, -- Show window title
				title_align = "center", -- Title alignment: 'left', 'center', or 'right'
			},

			custom_highlights = function(colors)
				return {
					Normal = { fg = colors.text, bg = colors.crust },
					NormalNC = { fg = colors.text, bg = colors.crust },

					NeoTreeNormal = { fg = colors.text, bg = colors.mantle },
					NeoTreeNormalNC = { fg = colors.text, bg = colors.mantle },

					Visual = { fg = colors.crust, bg = colors.red },
					TelescopeSelection = { fg = "#D388DF" },
					TelescopeSelectionCaret = { fg = "#D388DF" },

					TelescopePromptPrefix = { fg = "#D388DF" },
					TelescopePromptBorder = { bg = colors.mantle, fg = "#D388DF" },
					TelescopePromptTitle = { fg = "#D388DF" },

					TelescopeMatching = { fg = "#D97E6C" },

					["@lsp.type.macro.rust"] = { fg = colors.peach },
					["@lsp.type.enumMember.rust"] = { fg = colors.peach },
					["@lsp.type.namespace.rust"] = { fg = colors.lavender },
					["@lsp.type.formatSpecifier.rust"] = { fg = colors.pink },

					["@type.builtin"] = { fg = colors.yellow },
					["@property"] = { fg = colors.lavender },
					["@module"] = { fg = colors.lavender },
					["@variable.member"] = { fg = colors.lavender },
				}
			end,
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
