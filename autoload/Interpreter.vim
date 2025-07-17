vim9script

import "./Common.vim"
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

export class Interpreter
    def Interpret(expr: Expr): void
        try
            var value = this._Evaluate(expr)
            echo this._Stringify(value)
        catch
            Common.RuntimeError(v:exception)
        endtry
    enddef

    def _Evaluate(expr: Expr): any
        if instanceof(expr, Binary)
            var ex = <Binary>expr
            var left = this._Evaluate(ex.left)
            var right = this._Evaluate(ex.right)

            if ex.operator.type == TokenType.MINUS
                this._CheckNumberOperands(ex.operator, left, right)
                return <float>left - <float>right

            elseif ex.operator.type == TokenType.PLUS
                if type(left) == v:t_float && type(right) == v:t_float
                    return <float>left + <float>right
                elseif type(left) == v:t_string && type(right) == v:t_string
                    return <string>left .. <string>right
                endif
                throw this._RuntimeError(ex.operator, "Operand must be two numbers or two strings")

            elseif ex.operator.type == TokenType.SLASH
                this._CheckNumberOperands(ex.operator, left, right)
                return <float>left / <float>right

            elseif ex.operator.type == TokenType.STAR
                this._CheckNumberOperands(ex.operator, left, right)
                return <float>left * <float>right

            elseif ex.operator.type == TokenType.GREATER
                this._CheckNumberOperands(ex.operator, left, right)
                return <float>left > <float>right

            elseif ex.operator.type == TokenType.GREATER_EQUAL
                this._CheckNumberOperands(ex.operator, left, right)
                return <float>left >= <float>right

            elseif ex.operator.type == TokenType.LESS
                this._CheckNumberOperands(ex.operator, left, right)
                return <float>left < <float>right

            elseif ex.operator.type == TokenType.LESS_EQUAL
                this._CheckNumberOperands(ex.operator, left, right)
                return <float>left <= <float>right

            elseif ex.operator.type == TokenType.BANG_EQUAL
                return !this._IsEqual(left, right)

            elseif ex.operator.type == TokenType.EQUAL_EQUAL
                return this._IsEqual(left, right)
            endif

            # Unreachable.
            return null

        elseif instanceof(expr, Grouping)
            var ex = <Grouping>expr
            return this._Evaluate(ex.expression)

        elseif instanceof(expr, Literal)
            var ex = <Literal>expr
            return ex.value

        elseif instanceof(expr, Unary)
            var ex = <Unary>expr
            var right = this._Evaluate(ex.right)

            if ex.operator.type == TokenType.BANG
                return this._IsTruthy(right)
            elseif ex.operator.type == TokenType.MINUS
                this._CheckNumberOperand(ex.operator, right)
                return -(<float>right)
            endif

            # Unreachable.
            return null

        else
            return "not implemented"
        endif
    enddef

    def _IsEqual(a: any, b: any): bool
        if type(a) != type(b)
            return false
        else
            return a == b
        endif
    enddef

    # Only false and nil are falsey.
    def _IsTruthy(object: any): bool
        if object == null
            return false
        endif
        if type(object) == v:t_bool
            return <bool>object
        endif
        return true
    enddef

    def _CheckNumberOperand(operator: Token, operand: any): void
        if type(operand) == v:t_float
            return
        endif
        throw this._RuntimeError(operator, "Operand must be a number")
    enddef

    def _CheckNumberOperands(operator: Token, left: any, right: any): void
        if type(left) == v:t_float && type(right) == v:t_float
            return
        endif
        throw this._RuntimeError(operator, "Operand must be numbers")
    enddef

    def _RuntimeError(token: Token, message: string): string
        return $"{message}\n[line {token.line}]"
    enddef

    def _Stringify(object: any): string
        if object == null
            return "nil"
        endif
        if type(object) == v:t_float
            var text = string(object)
            if (text[-2 : -1] == ".0")
                text = text[0 : -3]
            endif
            return text
        endif
        return string(object)
    enddef
endclass

if !exists("g:vimlox_production")
    defc
endif
