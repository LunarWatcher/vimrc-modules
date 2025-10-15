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
            "--clang-tidy",
            # Seems to work, but this is fragile
            "--compile-commands-dir=./build",
        ],
        rootSearch: [
            "CMakeLists.txt"
        ]
    },
    "kotlin-lsp": {
        filetype: ["kotlin"],
        path: g:LspRoot .. "/kotlin-lsp/kotlin-lsp.sh",
        args: [
            "--stdio",
        ],
        syncInit: true,
        rootSearch: [
            "settings.gradle.kts",
            "build.gradle",
            "build.gradle.kts",
        ]
    },
    tsserver: {
        filetype: [
            "typescript", "javascript",
            "typescriptreact", "javascriptreact",
        ],
        path: g:LspRoot .. "/node_modules/.bin/typescript-language-server",
        args: ['--stdio'],
        rootSearch: [
            "package.json", "package-lock.json", "pnpm-lock.yaml"
        ],
        initializationOptions: {
            tsserver: {
                path: g:LspRoot .. "/node_modules/typescript/lib/tsserver.js"
            }
        }
    },
    # TODO: deno uses the system deno install, so resolving it cannot be done
    # with g:LspRoot. This is a rare exception where the LSP isn't separately
    # installed
    deno: {
        filetype: [
            "typescript", "javascript"
        ],
        path: 'deno',
        args: ['lsp'],
        initializationOptions: {
             enable: true,
             lint: true
        },
        rootSearch: [
            "deno.json"
        ],
        customNotificationHandlers: {
            "deno/didUpgradeCheck": (lspserver, reply) => {
                if reply.params.upgradeAvailable != null
                    echom "New Deno version available:" reply.params.upgradeAvailable
                endif
            },
            # Don't care
            "deno/didRefreshDenoConfigurationTree": (lspserver, reply) => {
            },
            "deno/didChangeDenoConfiguration": (lspserver, reply) => {
            },
        }
    },
    pyright: {
        filetype: [
            "python",
            "python.doxygen"
        ],
        path: g:LspRoot .. '/node_modules/.bin/pyright-langserver',
        args: ['--stdio'],
        workspaceConfig: {
            python: {
                pythonPath: './env/bin/python3'
            }
        },
        rootSearch: [
            "requirements.txt", "pyproject.toml"
        ]
    },
    luals: {
        filetype: [
            "lua"
        ],
        path: g:LspRoot .. "/luals/bin/lua-language-server",
        args: [],
        workspaceConfig: {
            Lua: {
                hint: {
                    enable: true
                }
            }
        }
    }
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
        var lsp: dict<any> = lsps[name]
        var callback: any = lsp->get("_liviPreload", null)
        if callback != null
            callback->call([])
        endif
        return copy(lsp)->extend({
            name: name
        })
    endif
    throw "Invalid LSP name: " .. name
enddef
