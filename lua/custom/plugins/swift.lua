return {
  -- Swift syntax highlighting
  {
    'keith/swift.vim',
    ft = 'swift',
  },

  -- Enhanced Swift support
  {
    'wojciech-kulik/xcodebuild.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('xcodebuild').setup()
    end,
  },
}
