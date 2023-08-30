" disable vi compatibility
set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-tree/nvim-tree.lua'

Plug 'mhinz/vim-signify'
Plug 'vim-test/vim-test'
Plug 'evanleck/vim-svelte', {'branch': 'main'}

Plug 'edkolev/tmuxline.vim'
call plug#end()

let g:tmuxline_powerline_separators = 0
colorscheme fmkhome
set termguicolors

syntax enable
filetype plugin indent on

" fzf
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

set undodir=~/.vim/undodir
set undofile

" show the line number
set number

" highlight the cursor row
set cursorline

" ignore case when searching
set ignorecase

" editor settings
set autoindent
set scrolloff=2

" to remove jitter when a warning is shown
set signcolumn

" show the currently typed command
set showcmd

" Use the syntax method of folding.
set foldmethod=syntax

" map tab to space
set expandtab
set softtabstop=4
set shiftwidth=4

" keyboard shortcuts
"
" ; as :
nnoremap ; :

nnoremap <C-a> :TestLast <CR>

nnoremap <C-n> :Files .<CR>
nnoremap <C-f> :Rg <CR>

nnoremap <C-s> <C-^>

let s:all_hidden = 0
function! ToggleHiddenAll()
    if s:all_hidden  == 0
        let s:all_hidden = 1
        set number!
        set signcolumn=no
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:all_hidden = 0
        set number
        set signcolumn=auto
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction

" Configure Plugins
lua <<EOF

-- nvim_lsp setup
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require'lspconfig'
local servers = {"tsserver", "intelephense", "pylsp", "hls", "ccls", "svelte"}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    flags = {
      debounce_text_changes = 500,
    },
    capabilities = capabilities,
  }
end

lspconfig.rust_analyzer.setup {
    flags = {
      debounce_text_changes = 500,
    }
}

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

-- nvim-tree setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 35,
  },
  renderer = {
    group_empty = true,
  },
})
EOF
