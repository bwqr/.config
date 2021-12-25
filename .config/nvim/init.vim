" disable vi compatibility
set nocompatible

call plug#begin('~/.vim/plugged')

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
" Extensions to built-in LSP, for example, providing type inlay hints
Plug 'nvim-lua/lsp_extensions.nvim'

Plug 'hrsh7th/nvim-compe'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'vim-test/vim-test'

Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'evanleck/vim-svelte', {'branch': 'main'}

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'

Plug 'chriskempson/base16-vim'

call plug#end()

colorscheme base16-default-dark

syntax enable
filetype plugin indent on


" nvim-compe
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:false
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:false
let g:compe.source.vsnip = v:false
let g:compe.source.ultisnips = v:false
let g:compe.source.luasnip = v:false
let g:compe.source.emoji = v:true

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

let g:svelte_preprocessor_tags = [ { 'name': 'ts', 'tag': 'script', 'as': 'typescript' } ]
let g:svelte_preprocessors = ['ts']

set undodir=~/.vim/undodir
set undofile

" Airline Tmuxline
let g:tmuxline_powerline_separators = 0

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert

" Avoid showing extra messages when using completion
set shortmess+=c

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
"set showcmd

" first <Tab> will complete to the longest common string, next <Tab> or
" <S-Tab> will start cycling 
set wildmenu
set wildmode=longest:full,full

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

nnoremap <C-n> :Files .<CR>
nnoremap <C-f> :Rg <CR>

nnoremap <C-s> <C-^>

" Configure LSP
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- function to attach completion when setting up lsp
-- local on_attach = function(client)
--    require'completion'.on_attach(client)
-- end

-- Enable rust_analyzer
-- nvim_lsp.rust_analyzer.setup({ on_attach=on_attach })
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches

local servers = {"rust_analyzer", "tsserver", "phpactor", "pyright", "hls", "ccls", "svelte"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 500,
    }
  }
end

-- angularls_cmd = {"npx", "ngserver", "--stdio", "--tsProbeLocations", "./" , "--ngProbeLocations", "./"}
-- nvim_lsp.angularls.setup{
--     cmd = angularls_cmd,
--     on_new_config = function(new_config, new_root_dir)
--         new_config.cmd = angularls_cmd
--     end,
-- }

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
EOF
