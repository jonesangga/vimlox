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

export class Parser
    final _tokens: list<Token>
    var   _current = 0

    def new(tokens: list<Token>)
        this._tokens = tokens
    enddef

    def Parse(): any
        try
            return this._Expression()
        catch
            echo "caught " .. v:exception
            return null
        endtry
    enddef

    # expression -> equality
    def _Expression(): Expr
        return this._Equality()
    enddef

    # equality -> comparison ( ( "!=" | "==" ) comparison )*
    def _Equality(): Expr
        var expr = this._Comparison()

        while this._Match(TokenType.BANG_EQUAL, TokenType.EQUAL_EQUAL)
            var operator = this._Previous()
            var right = this._Comparison()
            expr = Binary.new(expr, operator, right)
        endwhile

        return expr
    enddef

    # comparison -> term ( ( ">" | ">=" | "<" | "<=" ) term )*
    def _Comparison(): Expr
        var expr = this._Term()

        while this._Match(TokenType.GREATER, TokenType.GREATER_EQUAL, TokenType.LESS, TokenType.LESS_EQUAL)
            var operator = this._Previous()
            var right = this._Term()
            expr = Binary.new(expr, operator, right)
        endwhile

        return expr
    enddef

    # term -> factor ( ( "/" | "*" ) factor )*
    def _Term(): Expr
        var expr = this._Factor()

        while this._Match(TokenType.MINUS, TokenType.PLUS)
            var operator = this._Previous()
            var right = this._Factor()
            expr = Binary.new(expr, operator, right)
        endwhile

        return expr
    enddef

    # factor -> unary ( ( "/" | "*" ) unary )*
    def _Factor(): Expr
        var expr = this._Unary()

        while this._Match(TokenType.SLASH, TokenType.STAR)
            var operator = this._Previous()
            var right = this._Unary()
            expr = Binary.new(expr, operator, right)
        endwhile

        return expr
    enddef

    # unary -> ( "!" | "-" ) unary
    #        | primary
    def _Unary(): Expr
        if this._Match(TokenType.BANG, TokenType.MINUS)
            var operator = this._Previous()
            var right = this._Unary()
            return Unary.new(operator, right)
        endif

        return this._Primary()
    enddef

    # primary -> NUMBER | STRING | "true" | "false" | "nil"
    #          | "(" expression ")"
    def _Primary(): Expr
        if this._Match(TokenType.FALSE)
            return Literal.new(false)
        endif
        if this._Match(TokenType.TRUE)
            return Literal.new(true)
        endif
        if this._Match(TokenType.NIL)
            return Literal.new(null)
        endif

        if this._Match(TokenType.NUMBER, TokenType.STRING)
            return Literal.new(this._Previous().literal)
        endif

        if this._Match(TokenType.LEFT_PAREN)
            var expr = this._Expression()
            this._Consume(TokenType.RIGHT_PAREN, "Expect ')' after expression.")
            return Grouping.new(expr)
        endif

        throw this._Error(this._Peek(), "Expect expression")
    enddef

    def _Consume(type: TokenType, message: string): Token
        if this._Check(type)
            return this._Advance()
        endif

        throw this._Error(this._Peek(), message)
    enddef

    def _Error(token: Token, message: string): string
        Common.ParserError(token, message)
        return "Parser Error"
    enddef

    def _IsAtEnd(): bool
        return this._Peek().type == TokenType.EOF
    enddef

    def _Advance(): Token
        if !this._IsAtEnd()
            ++this._current
        endif
        return this._Previous()
    enddef

    def _Peek(): Token
        return this._tokens[this._current]
    enddef

    def _Check(type: TokenType): bool
        if this._IsAtEnd()
            return false
        endif
        return this._Peek().type == type
    enddef

    def _Match(...types: list<TokenType>): bool
        for type in types
            if this._Check(type)
                this._Advance()
                return true
            endif
        endfor

        return false
    enddef

    def _Previous(): Token
        return this._tokens[this._current - 1]
    enddef
endclass

if !exists("g:vimlox_production")
    defc
endif
