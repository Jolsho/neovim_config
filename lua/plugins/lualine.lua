return {
	"nvim-lualine/lualine.nvim",
	config = function()
        local c_color = "#2C6CB2"
        local b_color = "#4A90E2"
        local my_theme = require("lualine.themes.dracula")

        -- Normal/insert/visual/etc
        for _, mode in ipairs({"normal","insert","visual","replace","command"}) do
            my_theme[mode].c.bg = c_color
            my_theme[mode].b.bg = b_color
        end

        my_theme.normal.a.bg = "#ffffff"

        -- Inactive safely
        local inactive_color = { bg = "#1A3D5C", fg = "#ffffff" }
        my_theme.inactive.b = inactive_color
        my_theme.inactive.c = inactive_color

        require("lualine").setup({
            options = { theme = my_theme },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "diagnostics" },
                lualine_c = {
                    { 'filename', path = 1, shorting_target = 40 }  -- truncate path if longer than 40 chars
                },
                lualine_x = { "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        })
    end
}
