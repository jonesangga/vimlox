vim9script

import "./Token.vim" as Tok
import "./TokenType.vim" as TT

type Token = Tok.Token
type TokenType = TT.TokenType

export var hadError = false

export def Error(line: number, message: string): void
    Report(line, "", message)
enddef

export def ParserError(token: Token, message: string): void
    if token.type == TokenType.EOF
        Report(token.line, " at end", message)
    else
        Report(token.line, $" at '{token.lexeme}'", message)
    endif
enddef

def Report(line: number, where: string, message: string): void
    echo $"[line {line}] Error{where}: {message}"
    hadError = true
enddef

if !exists("g:vimlox_production")
    defc
endif
