-- [[ Configure LSP ]]

local function on_attach(lsp)
  --  This function gets run when an LSP connects to a particular buffer.
  return function (_, bufnr)
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    -- nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    --
    -- nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    -- nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    -- nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    -- nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    --
    --
    -- -- Lesser used LSP functionality
    -- nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    -- nmap('<leader>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, '[W]orkspace [L]ist Folders')
    --
    -- -- Create a command `:Format` local to the LSP buffer
    -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    --   vim.lsp.buf.format()
    -- end, { desc = 'Format current buffer with LSP' })

    -- see :help lsp-zero-keybindings
    lsp.default_keymaps({buffer = bufnr})

    -- See `:help K` for why this keymap
    nmap('<A-K>', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  end
end

return function(plugin, opts)
  -- Setup neovim lua configuration
  require('neodev').setup()

  local lsp = require('lsp-zero').preset(opts)

  lsp.setup_servers({'tsserver', 'eslint', 'pyright'})
  lsp.on_attach(on_attach(lsp))
  lsp.setup()

  -- (Optional) Configure lua language server for neovim
  require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
end
