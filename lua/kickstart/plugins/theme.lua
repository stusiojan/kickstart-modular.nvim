return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
        on_colors = function(colors)
          colors.bg = '#e0e0e0'
        end,
      }

      vim.cmd.colorscheme 'tokyonight-day'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
