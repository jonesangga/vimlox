vim9script

import "./Common.vim"
import "./Scanner.vim" as Scan
import "./Parser.vim" as Par
import "./AstPrinter.vim" as Printer

type Scanner = Scan.Scanner
type Parser = Par.Parser
type AstPrinter = Printer.AstPrinter

export def Run(source: string): void
    Common.hadError = false
    var scanner = Scanner.new(source)
    var tokens = scanner.ScanTokens()

    var parser = Parser.new(tokens)
    var expression = parser.Parse()

    # Stop if there was a syntax error.
    if Common.hadError
        return
    endif

    echo AstPrinter.new().Print(expression)

    # For now, just print the tokens.
    # for token in tokens
        # echo token
    # endfor
enddef

if !exists("g:vimlox_production")
    defc
endif
