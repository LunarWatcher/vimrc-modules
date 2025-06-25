vim9script
def AssertCorrectBuffer(): bool 
    if &ft == "fern"
        return false
    endif

    return true
enddef

def DebugDenoScript(script: string, ...args: list<string>)
    if !AssertCorrectBuffer()
        echoerr "You must be in a file buffer, or vimspector itself cannot handle launching your program"
        return
    endif
    if expand('%') == ""
        echoerr "You appear to be in an invalid buffer"
        return
    endif
    vimspector#LaunchWithConfigurations({
        "(Global) Deno: Launch script": {
            "adapter": "js-debug",
            "configuration": {
                "request": "launch",
                "program": script,
                "args": args,
                "runtimeExecutable": "deno",
                "runtimeArgs": [
                    "run",
                    "--inspect-wait",
                    "--allow-all"
                ],
                "attachSimplePort": 9229,
                "cwd": "${workspaceRoot}"
            },
            "breakpoints": {
                "exception": {
                    "all": "N",
                    "uncaught": "N"
                }
            }
        }
    })
enddef

def DebugCpp(executable: string, ...args: list<string>)
    if !AssertCorrectBuffer()
        echoerr "You must be in a file buffer, or vimspector itself cannot handle launching your program"
        return
    endif
    vimspector#LaunchWithConfigurations({
        "(Global) C++: GDB": {
            "adapter": "vscode-cpptools",
            "configuration": {
                "request": "launch",
                "program": "${cwd}/" .. executable,
                "args": args,
                "stopAtEntry": false,
                "MIMode": "gdb",
                "cwd": "${cwd}/build/",
                "externalConsole": true
            }
        }
    })
enddef

export def Init() 
    command! -nargs=+ -complete=file DebugDenoScript DebugDenoScript(<f-args>)
    command! -nargs=* DebugDenoSelf DebugDenoScript(expand('%:p'), <f-args>)
    command! -nargs=+ -complete=file DebugCpp DebugCpp(<f-args>)
enddef

