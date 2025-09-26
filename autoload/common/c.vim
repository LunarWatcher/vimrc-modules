vim9script

export def CheckNeedsDupeQuoteDeletion()
    var ev = v:event
    var word = ev.complete_word
    if (word == "")
        return
    endif

    # This won't work with #    include and other indented variants.
    # Not sure if this even matters
    #if stridx(getline('.'), "#include") != 0
        #return
    #endif

    # -1: col is 1-indexed, and for reasons, the cursor ends up being at the
    # very last quote, even though it doesn't look that way.
    if word[-1] == '"' && getline(".")[col(".") - 1] == '"'
        normal! "_x
    endif
enddef

export def Init()
    augroup LiviNukeDupeHeaderQuotes
        au!
        autocmd CompleteDone <buffer> CheckNeedsDupeQuoteDeletion()
    augroup END
enddef
