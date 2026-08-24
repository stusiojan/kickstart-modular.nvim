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
        'templ',
        'swift',
        'http',
        'json',
        'graphql',
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

      local history = {}

      local function select_node(node)
        if not node then
          return
        end
        local srow, scol, erow, ecol = node:range()

        -- node:range() returns an exclusive end. If it lands at column 0
        -- of the next line, back up to the end of the previous line.
        if ecol == 0 and erow > srow then
          erow = erow - 1
          local line = vim.api.nvim_buf_get_lines(0, erow, erow + 1, false)[1] or ''
          ecol = #line
        end

        -- Exit visual mode if we're already in it, so `normal! v` starts fresh
        -- instead of toggling visual mode off.
        if vim.fn.mode():match '^[vV\22]' then
          vim.cmd 'normal! \27'
        end

        vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
        vim.cmd 'normal! v'
        vim.api.nvim_win_set_cursor(0, { erow + 1, math.max(ecol - 1, 0) })
      end

      vim.keymap.set('n', '<CR>', function()
        local node = vim.treesitter.get_node()
        if not node then
          return
        end
        history = { node }
        select_node(node)
      end, { desc = 'Init treesitter selection' })

      vim.keymap.set('x', '<CR>', function()
        local cur = history[#history]
        if not cur then
          return
        end
        local parent = cur:parent()
        if not parent then
          return
        end
        table.insert(history, parent)
        select_node(parent)
      end, { desc = 'Increment treesitter selection' })

      vim.keymap.set('x', '<BS>', function()
        if #history <= 1 then
          return
        end
        table.remove(history)
        select_node(history[#history])
      end, { desc = 'Decrement treesitter selection' })
    end,
  },
}
