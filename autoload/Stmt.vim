vim9script

import "./Expr.vim" as Ex
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

if !exists("g:vimlox_production")
    defc
endif
