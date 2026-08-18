" Install Omnisearch
" Unmap Ctrl+O and Ctrl+I
" Unmap Ctrt+D and Ctrl+U

unmap <Space>
" let mapleader = " "
" exmap leader <Space>

set clipboard=unnamed

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>


exmap omnisearch_search obcommand omnisearch:show-modal
nmap <Space>/ :omnisearch_search<CR>

exmap open obcommand switcher:open
nmap <Space><Space> :open<CR>

exmap follow obcommand editor:follow-link
nmap gd :follow<CR>

exmap command_palette_open obcommand command-palette:open
nmap ga :command_palette_open<CR>

exmap today obcommand daily-notes
nmap <Space>t :today<CR>
