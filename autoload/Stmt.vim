vim9script

import "./Token.vim" as Tok
import "./Expr.vim" as Ex

type Token = Tok.Token
type Expr = Ex.Expr

export abstract class Stmt
endclass

export class Expression extends Stmt
    def new(expression: Expr)
        this.expression = expression
    enddef

    final expression: Expr
endclass

export class Print extends Stmt
    def new(expression: Expr)
        this.expression = expression
    enddef

    final expression: Expr
endclass

export class Var extends Stmt
    def new(name: Token, initializer: Expr)
        this.name = name
        this.initializer = initializer
    enddef

    final name: Token
    final initializer: Expr
endclass

if !exists("g:vimlox_production")
    defc
endif
