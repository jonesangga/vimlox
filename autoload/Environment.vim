vim9script

import "./Token.vim" as Tok
type Token = Tok.Token

export class Environment
    final _values: dict<any> = {}

    def Define(name: string, value: any): void
        this._values[name] = value
    enddef

    def Get(name: Token): any
        if this._values->has_key(name.lexeme)
            return this._values[name.lexeme]
        endif
        throw $"Undefined variable '{name.lexeme}'.\n[line {name.line}]"
    enddef
endclass

if !exists("g:vimlox_production")
    defc
endif
