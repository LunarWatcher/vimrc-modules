vim9script
def AssertCorrectBuffer(): bool 
    if &ft == "fern"
        return false
    endif

    return true
enddef

def DebugDenoScript(script: string)
    if !AssertCorrectBuffer()
        echoerr "You must be in a file buffer, or vimspector itself cannot handle launching your program"
        return
    endif
    vimspector#LaunchWithConfigurations({
        "(Global) Deno: Launch script": {
            "adapter": "js-debug",
            "configuration": {
                "request": "launch",
                "program": script,
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

def DebugCpp(executable: string)
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
                "stopAtEntry": false,
                "MIMode": "gdb",
                "cwd": "${cwd}/build/",
                "externalConsole": true
            }
        }
    })
enddef

export def Init() 
    command! -nargs=1 -complete=file DebugDenoScript DebugDenoScript(<f-args>)
    command! -nargs=0 DebugDenoSelf DebugDenoScript(expand('%:p'))
    command! -nargs=1 -complete=file DebugCpp DebugCpp(<f-args>)
enddef

