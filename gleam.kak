# http://gleam.run
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](gleam) %{
    set-option buffer filetype gleam
    set-option buffer comment_line '//'
    set-option buffer indentwidth 2
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=gleam %[
    require-module gleam
    hook window ModeChange pop:insert:.* -group gleam-trim-indent gleam-trim-indent
    hook window InsertChar \n -group gleam-indent gleam-indent-on-new-line
    hook window InsertChar \{ -group gleam-indent gleam-indent-on-opening-curly-brace
    hook window InsertChar [)}] -group gleam-indent gleam-indent-on-closing
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window gleam-.+ }
]

hook -group gleam-highlight global WinSetOption filetype=gleam %{
    add-highlighter window/gleam ref gleam
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/gleam }
}

provide-module gleam %§

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/gleam regions
add-highlighter shared/gleam/code default-region group
add-highlighter shared/gleam/string           region %{(?<!')"} (?<!\\)(\\\\)*"           fill string
add-highlighter shared/gleam/module_doc       region "////" "$"                           fill documentation
add-highlighter shared/gleam/documentation    region "///" "$"                            fill documentation
add-highlighter shared/gleam/line_comment     region "//" "$"                             fill comment

add-highlighter shared/gleam/code/            regex \b[a-z][a-z_0-9]*\b            0:variable
add-highlighter shared/gleam/code/            regex \b[A-Z]\w*\b                   0:type
add-highlighter shared/gleam/code/            regex \b_\w*\b                       0:comment
add-highlighter shared/gleam/code/            regex fn\s([a-z]\w*)\b               1:function
add-highlighter shared/gleam/code/            regex (\b[a-z]\w*)\(                 1:function
add-highlighter shared/gleam/code/            regex \b([a-z]\w*)\.                 1:module
add-highlighter shared/gleam/code/            regex import\s([a-z]\w*)             1:module
add-highlighter shared/gleam/code/            regex /([a-z]\w*)                    1:module
add-highlighter shared/gleam/code/            regex [-+<>!@#$%^&*=:/\\|\\.]+       0:operator

add-highlighter shared/gleam/code/ regex \b(?:[0-9][_0-9]*(?:\.[0-9][_0-9]*|(?:\.[0-9][_0-9]*)?E[\+\-][_0-9]+)|(?:0x[_0-9a-fA-F]+|0o[_0-7]+|0b[_01]+|[0-9][_0-9]*))\b 0:value
add-highlighter shared/gleam/code/ regex (\b(as|assert|case|const|external|fn|if|import|let|opaque|pub|todo|try|tuple|type)\b) 0:keyword

# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden gleam-trim-indent %{
    # remove trailing white spaces
    try %{ execute-keys -draft -itersel <a-x> s \h+$ <ret> d }
}

define-command -hidden gleam-indent-on-new-line %~
    evaluate-commands -draft -itersel %<
        # copy // comments prefix and following white spaces
        try %{
            execute-keys -draft k <a-x> s ^\h*\K///?/?\h* <ret> y gh j P
        } catch %|
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }
            # indent after lines ending with { or (
            try %[ execute-keys -draft k <a-x> <a-k> [{(]\h*$ <ret> j <a-gt> ]
            # indent after lines ending with [{(].+ and move first parameter to own line
            try %< execute-keys -draft [c[({],[)}] <ret> <a-k> \A[({][^\n]+\n[^\n]*\n?\z <ret> L i<ret><esc> <gt> <a-S> <a-&> >
        |
        # filter previous line
        try %{ execute-keys -draft k : gleam-trim-indent <ret> }
    >
~

define-command -hidden gleam-indent-on-opening-curly-brace %[
    evaluate-commands -draft -itersel %_
        # align indent with opening paren when { is entered on a new line after the closing paren
        try %[ execute-keys -draft h <a-F> ) M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
    _
]

define-command -hidden gleam-indent-on-closing %[
    evaluate-commands -draft -itersel %_
        # align to opening curly brace or paren when alone on a line
        try %< execute-keys -draft <a-h> <a-k> ^\h*[)}]$ <ret> h m <a-S> 1<a-&> >
    _
]

§


