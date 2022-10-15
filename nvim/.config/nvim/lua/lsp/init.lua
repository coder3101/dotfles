local nvim_lsp = require("lspconfig")
local custom_attach = require("lsp.mappings")

local servers = { "clangd", "cmake", "gopls", "metals", "pyright", "rust_analyzer", "tsserver", "yamlls", "jsonls"}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
      on_attach = custom_attach,
      capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  }
end


require'lspconfig'.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
  on_attach = custom_attach,
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

local rustopts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = false,
        on_initialized = function (_)
            print("Rust analyzer: Workspace initialised")
        end,
        inlay_hints = {
            parameter_hints_prefix = " ← ",
            other_hints_prefix = " → ",
        }
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        on_attach = custom_attach,
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(rustopts)
require("lsp.tweaks")
require("lsp.cmp")
