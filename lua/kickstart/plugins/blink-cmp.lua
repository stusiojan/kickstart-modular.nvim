return {
  { -- autocompletion
    'saghen/blink.cmp',
    event = 'vimenter',
    version = '1.*',
    dependencies = {
      -- snippet engine
      {
        'l3mon4d3/luasnip',
        version = '2.*',
        build = (function()
          -- build step is needed for regex support in snippets.
          -- this step is not supported in many windows environments.
          -- remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    see the readme about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load {
                include = { 'swift', 'c', 'lua', 'go', 'python' },
              }
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    this will auto-import if your lsp supports it.
        --    this will expand snippets if the lsp sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- for an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- no, but seriously. please read `:help ins-completion`, it is really good!
        --
        -- all presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: select next/previous item
        -- <c-e>: hide menu
        -- <c-k>: toggle signature help
        --
        -- see :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- for more advanced luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/l3mon4d3/luasnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'nerd font mono' or 'normal' for 'nerd font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- by default, you may press `<c-space>` to show the documentation.
        -- optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- by default, we use the lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- see :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
