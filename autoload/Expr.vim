vim9script

import "./Token.vim" as Tok
type Token = Tok.Token

export interface Visitor
    def Visit(expr: any): string
endinterface

export abstract class Expr
    abstract def Accept(visitor: Visitor): string
endclass

export class Binary extends Expr
    def new(left: Expr, operator: Token, right: Expr)
        this.left = left
        this.operator = operator
        this.right = right
    enddef

    def Accept(visitor: Visitor): string
        return visitor.Visit(this)
    enddef

    final left: Expr
    final operator: Token
    final right: Expr
endclass

export class Grouping extends Expr
    def new(expression: Expr)
        this.expression = expression
    enddef

    def Accept(visitor: Visitor): string
        return visitor.Visit(this)
    enddef

    final expression: Expr
endclass

export class Literal extends Expr
    def new(value: any)
        this.value = value
    enddef

    def Accept(visitor: Visitor): string
        return visitor.Visit(this)
    enddef

    final value: any
endclass

export class Unary extends Expr
    def new(operator: Token, right: Expr)
        this.operator = operator
        this.right = right
    enddef

    def Accept(visitor: Visitor): string
        return visitor.Visit(this)
    enddef

    final operator: Token
    final right: Expr
endclass

export interface VisitorNext
    def VisitBinaryExpr(expr: Binary): string
    def VisitGroupingExpr(expr: Grouping): string
    def VisitLiteralExpr(expr: Literal): string
    def VisitUnaryExpr(expr: Unary): string
endinterface

if !exists("g:vimlox_production")
    defc
endif
