-- LaTeX workflow: VimTeX + Skim + LuaSnip
return {
  {
    'lervag/vimtex',
    lazy = false,
    ft = { 'tex', 'latex', 'plaintex', 'bib' },
    init = function()
      if not vim.env.PATH:find('/Library/TeX/texbin', 1, true) then
        vim.env.PATH = '/Library/TeX/texbin:' .. vim.env.PATH
      end

      vim.g.vimtex_view_method = 'skim'
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_view_skim_reading_bar = 1

      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = 'build',
        out_dir = 'build',
        callback = 1,
        continuous = 1,
        executable = 'latexmk',
        hooks = {},
        options = {
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
        },
      }

      vim.g.vimtex_quickfix_mode = 2
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_mappings_prefix = '<localleader>'

      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        ligatures = 1,
        cites = 1,
        fancy = 1,
        spacing = 0,
        greek = 1,
        math_bounds = 0,
        math_delimiters = 1,
        math_fracs = 1,
        math_super_sub = 1,
        math_symbols = 1,
        sections = 0,
        styles = 1,
      }

      vim.g.vimtex_indent_enabled = 1
      vim.g.vimtex_fold_enabled = 0

      vim.g.tex_flavor = 'latex'
      vim.g.tex_conceal = 'abdmg'
    end,
    config = function()
      local snippets_loaded = false
      local function load_luasnip()
        if snippets_loaded then
          return
        end
        local ok, ls = pcall(require, 'luasnip')
        if not ok then
          return
        end
        ls.config.set_config {
          history = true,
          updateevents = 'TextChanged,TextChangedI',
          enable_autosnippets = true,
          store_selection_keys = '<Tab>',
        }
        require('luasnip.loaders.from_lua').load {
          paths = { vim.fn.stdpath 'config' .. '/snippets' },
        }
        vim.keymap.set({ 'i', 's' }, '<C-l>', function()
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end, { desc = 'LuaSnip next choice' })
        snippets_loaded = true
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'tex', 'latex', 'plaintex' },
        callback = function(args)
          load_luasnip()
          vim.opt_local.conceallevel = 2
          vim.opt_local.spell = true
          vim.opt_local.spelllang = 'pl,en_us'
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.textwidth = 0
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2

          local map = function(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = args.buf, desc = desc })
          end
          map('<leader>ll', '<cmd>VimtexCompile<cr>', 'LaTeX: compile toggle')
          map('<leader>lv', '<cmd>VimtexView<cr>', 'LaTeX: view PDF')
          map('<leader>lc', '<cmd>VimtexClean<cr>', 'LaTeX: clean aux')
          map('<leader>lC', '<cmd>VimtexClean!<cr>', 'LaTeX: clean all incl. PDF')
          map('<leader>le', '<cmd>VimtexErrors<cr>', 'LaTeX: errors')
          map('<leader>ls', '<cmd>VimtexStop<cr>', 'LaTeX: stop compile')
          map('<leader>lt', '<cmd>VimtexTocToggle<cr>', 'LaTeX: TOC')
          map('<leader>li', '<cmd>VimtexInfo<cr>', 'LaTeX: info')
          map('<leader>lr', '<cmd>VimtexReload<cr>', 'LaTeX: reload plugin')
        end,
      })
    end,
  },

}
