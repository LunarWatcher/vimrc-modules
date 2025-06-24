vim9script

if get(g:, 'VimrcModulesCustomLoad', 0) == 1
    finish
endif

# Windows has historically not been supported. It's apparently experimentally
# supported now, but until it's stable, this remains conditional (matching my
# vimrc)
if !has("win32") && !has("win32unix")
    import autoload "modules/vimspector.vim" as vimsp
    vimsp.Init()
endif

