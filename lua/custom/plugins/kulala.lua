-- Klient REST/HTTP w Neovimie (pliki .http / .rest)
return {
  'mistweaverco/kulala.nvim',
  ft = { 'http', 'rest' },
  keys = {
    { '<leader>R', '', desc = '[R]EST (kulala)', ft = { 'http', 'rest' } },
    {
      '<leader>Rs',
      function()
        require('kulala').run()
      end,
      desc = '[S]end request',
      ft = { 'http', 'rest' },
    },
    {
      '<leader>Ra',
      function()
        require('kulala').run_all()
      end,
      desc = 'Send [A]ll requests',
      ft = { 'http', 'rest' },
    },
    {
      '<leader>Rr',
      function()
        require('kulala').replay()
      end,
      desc = '[R]eplay last request',
      ft = { 'http', 'rest' },
    },
    {
      '<leader>Rt',
      function()
        require('kulala').toggle_view()
      end,
      desc = '[T]oggle body/headers',
      ft = { 'http', 'rest' },
    },
    {
      '<leader>Rn',
      function()
        require('kulala').jump_next()
      end,
      desc = '[N]ext request',
      ft = { 'http', 'rest' },
    },
    {
      '<leader>Rp',
      function()
        require('kulala').jump_prev()
      end,
      desc = '[P]revious request',
      ft = { 'http', 'rest' },
    },
    {
      '<leader>Rc',
      function()
        require('kulala').copy()
      end,
      desc = '[C]opy as curl',
      ft = { 'http', 'rest' },
    },
    {
      '<leader>Ri',
      function()
        require('kulala').inspect()
      end,
      desc = '[I]nspect request',
      ft = { 'http', 'rest' },
    },
    {
      '<leader>Re',
      function()
        require('kulala').set_selected_env()
      end,
      desc = 'Select [E]nvironment',
      ft = { 'http', 'rest' },
    },
    {
      '<leader>Rq',
      function()
        require('kulala').close()
      end,
      desc = '[Q]uit kulala window',
      ft = { 'http', 'rest' },
    },
  },
  opts = {
    global_keymaps = false,
  },
}
