return {
  'hat0uma/csvview.nvim',
  ---@module "csvview"
  ---@type CsvView.Options
  opts = {
    parser = {
      async_chunksize = 50,
      delimiter = {
        ft = {
          csv = ',',
          tsv = '\t',
        },
        fallbacks = {
          ',',
          '\t',
          ';',
          '|',
          ':',
          ' ',
        },
      },
      quote_char = '"',
      comments = { '#', '//' },
      comment_lines = nil,
      max_lookahead = 50,
    },
    view = {
      min_column_width = 5,
      spacing = 2,
      display_mode = 'highlight',
      header_lnum = true,
      sticky_header = {
        enabled = true,
        separator = '─',
      },
    },
    keymaps = {
      textobject_field_inner = { 'if', mode = { 'o', 'x' } },
      textobject_field_outer = { 'af', mode = { 'o', 'x' } },
      jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
      jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
      jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
      jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
    },
  },
  ft = { 'csv', 'tsv' },
  config = function(_, opts)
    require('csvview').setup(opts)

    -- Kolorowe kolumny — każda kolumna inny kolor, powtarzają się co 9
    vim.api.nvim_set_hl(0, 'CsvViewCol0', { fg = '#e06c75' }) -- czerwony
    vim.api.nvim_set_hl(0, 'CsvViewCol1', { fg = '#e5c07b' }) -- żółty
    vim.api.nvim_set_hl(0, 'CsvViewCol2', { fg = '#98c379' }) -- zielony
    vim.api.nvim_set_hl(0, 'CsvViewCol3', { fg = '#56b6c2' }) -- cyan
    vim.api.nvim_set_hl(0, 'CsvViewCol4', { fg = '#61afef' }) -- niebieski
    vim.api.nvim_set_hl(0, 'CsvViewCol5', { fg = '#c678dd' }) -- fioletowy
    vim.api.nvim_set_hl(0, 'CsvViewCol6', { fg = '#d19a66' }) -- pomarańczowy
    vim.api.nvim_set_hl(0, 'CsvViewCol7', { fg = '#be5046' }) -- ciemnoczerwony
    vim.api.nvim_set_hl(0, 'CsvViewCol8', { fg = '#7ec8e3' }) -- jasnoniebieski

    -- Automatyczne włączanie widoku CSV przy otwarciu pliku
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'csv', 'tsv' },
      callback = function()
        require('csvview').enable()

        local wk = require 'which-key'
        wk.add {
          { '<leader>C', group = '[C]SV', buffer = true },
          { '<leader>Ct', '<cmd>CsvViewToggle<cr>', desc = '[T]oggle', buffer = true },
          { '<leader>Ce', '<cmd>CsvViewEnable<cr>', desc = '[E]nable', buffer = true },
          { '<leader>Cd', '<cmd>CsvViewDisable<cr>', desc = '[D]isable', buffer = true },
          {
            '<leader>Ci',
            function()
              vim.notify(
                'CSV Navigation:\n'
                  .. '  Tab        → następne pole (w prawo)\n'
                  .. '  Shift+Tab  → poprzednie pole (w lewo)\n'
                  .. '  Enter      → wiersz w dół\n'
                  .. '  Shift+Enter→ wiersz w górę\n'
                  .. '  if         → zaznacz wewnątrz pola (text object)\n'
                  .. '  af         → zaznacz całe pole (text object)',
                vim.log.levels.INFO,
                { title = 'CSV Navigation' }
              )
            end,
            desc = 'Navigation [I]nstructions',
            buffer = true,
          },
        }
      end,
    })
  end,
}
