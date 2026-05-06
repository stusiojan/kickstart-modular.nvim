-- return {
--   { -- Highlight, edit, and navigate code
--     'nvim-treesitter/nvim-treesitter',
--     branch = 'master',
--     build = ':TSUpdate',
--     main = 'nvim-treesitter.configs', -- Sets main module to use for opts
--     -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
--     opts = {
--       ensure_installed = {
--         'bash',
--         'c',
--         'diff',
--         'html',
--         'lua',
--         'luadoc',
--         'markdown',
--         'markdown_inline',
--         'query',
--         'vim',
--         'vimdoc',
--         'python',
--         'go',
--         'gomod',
--         'gosum',
--         'swift',
--       },
--       -- Autoinstall languages that are not installed
--       auto_install = true,
--       highlight = {
--         enable = true,
--         -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
--         --  If you are experiencing weird indenting issues, add the language to
--         --  the list of additional_vim_regex_highlighting and disabled languages for indent.
--         additional_vim_regex_highlighting = { 'ruby' },
--       },
--       indent = { enable = true, disable = { 'ruby' } },
--     },
--     -- There are additional nvim-treesitter modules that you can use to interact
--     -- with nvim-treesitter. You should go explore a few and see what interests you:
--     --
--     --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
--     --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
--     --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--   },
-- }
-- vim: ts=2 sts=2 sw=2 et
--
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()

      local parsers = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'python',
        'go',
        'gomod',
        'gosum',
        'swift',
      }
      require('nvim-treesitter').install(parsers)

      -- Enable highlighting + indent on FileType
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          if ft == 'ruby' then
            return
          end -- your old ruby exclusion
          local ok = pcall(vim.treesitter.start, args.buf)
          if ok then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
