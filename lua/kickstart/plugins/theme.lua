return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      -- Function to detect macOS system appearance
      local function get_system_appearance()
        local handle = io.popen 'defaults read -g AppleInterfaceStyle 2>/dev/null'
        if handle then
          local result = handle:read '*a'
          handle:close()
          -- If the command returns "Dark", system is in dark mode
          return result:match 'Dark' and 'dark' or 'light'
        end
        return 'light' -- fallback to light mode
      end

      -- Setup tokyonight with both light and dark configurations
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
        on_colors = function(colors)
          -- Only modify background for light mode
          if vim.o.background == 'light' then
            colors.bg = '#e0e0e0'
          end
        end,
      }

      -- Detect system appearance and set colorscheme accordingly
      local system_appearance = get_system_appearance()

      if system_appearance == 'dark' then
        vim.o.background = 'dark'
        vim.cmd.colorscheme 'tokyonight-night' -- or 'tokyonight-storm'
      else
        vim.o.background = 'light'
        vim.cmd.colorscheme 'tokyonight-day'
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
