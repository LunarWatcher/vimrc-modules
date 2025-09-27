vim9script

# This file is based on https://github.com/scy/vim-mkdir-on-write/blob/master/plugin/vim-mkdir-on-write.vim

def CreateDirsIfNotExists(file: any, buf: any)
    if empty(getbufvar(buf, '&buftype')) && file !~# '\v^\w+\:\/'
        var dir = fnamemodify(file, ':h')
        if !isdirectory(dir)
            mkdir(dir, 'p')
        endif
    endif
enddef

augroup MkdirOnWrite
    autocmd!
    autocmd BufWritePre * CreateDirsIfNotExists(expand('<afile>'), expand('<abuf>'))
augroup END
