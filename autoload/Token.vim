vim9script

import "./TokenType.vim" as TT

type TokenType = TT.TokenType

export class Token
    const type:    TokenType
    const lexeme:  string
    const literal: any
    const line:    number

    def new(type: TokenType, lexeme: string, literal: any, line: number)
        this.type    = type
        this.lexeme  = lexeme
        this.literal = literal
        this.line    = line
    enddef

    # NOTE: This is builtin to get textural representation of the class.
    def string(): string
        return $"{this.type.name} {this.lexeme} {string(this.literal)}"
    enddef
endclass

if !exists("g:vimlox_production")
    defc
endif
