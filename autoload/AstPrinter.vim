vim9script

import "./Token.vim" as Tok
import "./TokenType.vim" as TT
import "./Expr.vim" as Ex

type Token = Tok.Token
type TokenType = TT.TokenType

type Expr = Ex.Expr
type Binary = Ex.Binary
type Grouping = Ex.Grouping
type Literal = Ex.Literal
type Unary = Ex.Unary

export def AstPrinter(expr: Expr): string
    if instanceof(expr, Binary)
        var ex = <Binary>expr
        return Parenthesize(ex.operator.lexeme, ex.left, ex.right)

    elseif instanceof(expr, Grouping)
        var ex = <Grouping>expr
        return Parenthesize("group", ex.expression)

    elseif instanceof(expr, Literal)
        var ex = <Literal>expr
        if ex.value == null
            return "nil"
        endif
        return string(ex.value)

    elseif instanceof(expr, Unary)
        var ex = <Unary>expr
        return Parenthesize(ex.operator.lexeme, ex.right)

    else
        return "not implemented"
    endif

enddef

def Parenthesize(name: string, ...exprs: list<Expr>): string
    var text = $"({name}"
    for expr in exprs
        text ..= " "
        text ..= AstPrinter(expr)
    endfor
    text ..= ")"
    return text
enddef

# Testing. Delete later.
# (* (- 123) (group 45.67))
# var expression = Binary.new(
    # Unary.new(
        # Token.new(TokenType.MINUS, "-", null, 1),
        # Literal.new(123)
    # ),
    # Token.new(TokenType.STAR, "*", null, 1),
    # Grouping.new(Literal.new(45.67))
# )

# echo AstPrinter(expression)

if !exists("g:vimlox_production")
    defc
endif
