return {
  'mikavilpas/yazi.nvim',
  version = '*',
  event = 'VeryLazy',
  dependencies = {
    { 'nvim-lua/plenary.nvim', lazy = true },
  },
  keys = {
    { '<leader>-', '<cmd>Yazi<cr>', desc = 'Open yazi at current file', mode = { 'n', 'v' } },
    { '<leader>cw', '<cmd>Yazi cwd<cr>', desc = 'Open yazi in working directory' },
    { '<c-up>', '<cmd>Yazi toggle<cr>', desc = 'Resume last yazi session' },
  },
  ---@type YaziConfig | {}
  opts = {
    open_for_directories = true,
    keymaps = {
      show_help = '<f1>',
    },
  },
  init = function()
    vim.g.loaded_netrwPlugin = 1
  end,
}
