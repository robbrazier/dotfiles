local add, later = Config.add, Config.later

-- Formatting --

later(function()
  add { 'https://github.com/stevearc/conform.nvim' }

  local ensure = { 'stylua', 'gofumpt', 'ruff' }
  local registry = require 'mason-registry'
  registry.refresh(function()
    for _, name in ipairs(ensure) do
      local ok, pkg = pcall(registry.get_package, name)
      if ok and not pkg:is_installed() then
        pkg:install()
      end
    end
  end)

  require('conform').setup {
    default_format_opts = {
      -- Allow formatting from LSP server if no dedicated formatter is available
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format' },
      go = { 'gofumpt' },
    },
  }

  Config.new_autocmd('BufWritePre', '*', function(args)
    require('conform').format { bufnr = args.buf }
  end, 'Format on Save')
end)

later(function()
  add { 'https://github.com/nmac427/guess-indent.nvim' }
  require('guess-indent').setup()
end)

-- Snippets --

later(function()
  add { 'https://github.com/rafamadriz/friendly-snippets' }
end)
