vim9script

import "./Token.vim" as Tok
type Token = Tok.Token

export abstract class Expr
endclass

export class Binary extends Expr
    def new(left: Expr, operator: Token, right: Expr)
        this.left = left
        this.operator = operator
        this.right = right
    enddef

    final left: Expr
    final operator: Token
    final right: Expr
endclass

export class Grouping extends Expr
    def new(expression: Expr)
        this.expression = expression
    enddef

    final expression: Expr
endclass

export class Literal extends Expr
    def new(value: any)
        this.value = value
    enddef

    final value: any
endclass

export class Unary extends Expr
    def new(operator: Token, right: Expr)
        this.operator = operator
        this.right = right
    enddef

    final operator: Token
    final right: Expr
endclass

export class Variable extends Expr
    def new(name: Token)
        this.name = name
    enddef

    final name: Token
endclass

if !exists("g:vimlox_production")
    defc
endif
