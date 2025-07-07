vim9script

import "./Token.vim" as Tok
import "./TokenType.vim" as TT
import "./Expr.vim" as Ex

type Token = Tok.Token
type TokenType = TT.TokenType

type Visitor = Ex.Visitor
type VisitorNext = Ex.VisitorNext
type Expr = Ex.Expr
type Binary = Ex.Binary
type Grouping = Ex.Grouping
type Literal = Ex.Literal
type Unary = Ex.Unary

class AstPrinter implements Visitor, VisitorNext
    def Print(expr: Expr): string
        return expr.Accept(this)
    enddef

    def Visit(expr: any): string
        var type = typename(expr)
        if type == 'object<Binary>'
            return this.VisitBinaryExpr(expr)
        elseif type == 'object<Grouping>'
            return this.VisitGroupingExpr(expr)
        elseif type == 'object<Literal>'
            return this.VisitLiteralExpr(expr)
        elseif type == 'object<Unary>'
            return this.VisitUnaryExpr(expr)
        else
            return "not implemented"
        endif
    enddef

    def VisitBinaryExpr(expr: Binary): string
        return this._Parenthesize(expr.operator.lexeme, expr.left, expr.right)
    enddef

    def VisitGroupingExpr(expr: Grouping): string
        return this._Parenthesize("group", expr.expression)
    enddef

    def VisitLiteralExpr(expr: Literal): string
        if expr.value == null
            return "nil"
        endif
        return string(expr.value)
    enddef

    def VisitUnaryExpr(expr: Unary): string
        return this._Parenthesize(expr.operator.lexeme, expr.right)
    enddef

    def _Parenthesize(name: string, ...exprs: list<Expr>): string
        var text = $"({name}"
        for expr in exprs
            text ..= " "
            text ..= expr.Accept(this)
        endfor
        text ..= ")"
        return text
    enddef
endclass

# Testing. Delete later.
# (* (- 123) (group 45.67))
var expression = Binary.new(
    Unary.new(
        Token.new(TokenType.MINUS, "-", null, 1),
        Literal.new(123)
    ),
    Token.new(TokenType.STAR, "*", null, 1),
    Grouping.new(Literal.new(45.67))
)

echo AstPrinter.new().Print(expression)

if exists('g:vimlox_development')
    defc
endif
