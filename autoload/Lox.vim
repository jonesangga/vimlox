vim9script

import "./Common.vim"
import "./Scanner.vim" as Scan

type Scanner = Scan.Scanner

export def Run(source: string): void
    Common.hadError = false
    var scanner = Scanner.new(source)
    var tokens = scanner.ScanTokens()

    # For now, just print the tokens.
    for token in tokens
        echo token
    endfor
enddef

if exists('g:vimlox_development')
    defc
endif
