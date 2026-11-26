local add, now_if_args = Config.add, Config.now_if_args

-- Tree-sitter --

now_if_args(function()
  local ts_update = function()
    vim.cmd 'TSUpdate'
  end
  Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

  add {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  }

  local languages = {
    'bash',
    'css',
    'diff',
    'dockerfile',
    'go',
    'html',
    'ini',
    'javascript',
    'json',
    'latex',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'python',
    'regex',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'xml',
    'yaml',
    'gotmpl',
  }

  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then
    require('nvim-treesitter').install(to_install)
  end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end
  Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
end)

now_if_args(function()
  add { 'https://github.com/mason-org/mason.nvim' }
  require('mason').setup()
end)

-- Language servers --
now_if_args(function()
  add {
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason-lspconfig.nvim',
  }

  local servers = {
    'lua_ls',
    'gopls',
    'golangci_lint_ls',
    'templ',
    'superhtml',
    'ts_ls', -- typescript
    'taplo', -- toml
    'yamlls',
    'jsonls',
    'tofu_ls',
    'ruff',
    'basedpyright',
    'bashls',
  }

  require('mason-lspconfig').setup {
    ensure_installed = servers,
    automatic_enable = true,
  }
end)
