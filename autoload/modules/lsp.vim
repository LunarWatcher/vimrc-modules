vim9script

#let lsps = [{
#\ "name": "clangd",
#\ "filetype": ["c", "cpp"],
#\ "path": "/usr/bin/clangd",
#\ "args": ["--background-index"]
#\ }]

if has("linux")
    g:LspRoot = $HOME .. "/.local/share/lsp"
else
    g:LspRoot = "/tmp"
endif
var lsps = {
    clangd: {
        filetype: ["c", "cpp", "cpp.doxygen", "c.doxygen"],
        path: g:LspRoot .. "/clangd/bin/clangd",
        args: [
            "--background-index",
            "--clang-tidy"
        ],
        rootSearch: [
            "CMakeLists.txt"
        ]
    },
    "kotlin-lsp": {
        filetype: ["kotlin"],
        path: g:LspRoot .. "/kotlin-lsp/bin/kotlin-lsp.sh",
        args: [
            "--stdio",
        ],
        rootSearch: [
            "settings.gradle.kts"
        ]
    },
    tsserver: {
        filetype: [
            "typescript", "javascript",
            "typescriptreact", "javascriptreact",
        ],
        path: g:LspRoot .. "/node_modules/.bin/typescript-language-server",
        args: ['--stdio']
    },
    # TODO: deno uses the system deno install, so resolving it cannot be done
    # with g:LspRoot. This is a rare exception where the LSP isn't separately
    # installed
    # TODO: figure out how to differentiate whether to use deno or tsserver
    # for a given buffer. Likely need a command to switch.
    deno: {
        filetype: [
            "typescript", "javascript"
        ],
        path: 'deno',
        args: ['lsp'],
        debug: true,
        initializationOptions: {
             enable: true,
             lint: true
        }
    },
    pyright: {
        filetype: [
            "python"
        ],
        path: g:LspRoot .. '/node_modules/.bin/pyright-langserver',
        args: ['--stdio'],
        workspaceConfig: {
            python: {
                pythonPath: 'python3'
            }
        }
    },
}
export def Location(name: string): dict<any>
    if has("mac")
        echoerr "No"
    endif
    if has("win32")
        # TODO: add windows support
        return {}
    endif

    if lsps->has_key(name)
        return copy(lsps[name])->extend({
            name: name
        })
    endif
    throw "Invalid LSP name: " .. name
enddef
