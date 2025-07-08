vim9script

import "./Common.vim"
import "./Token.vim" as Tok
import "./TokenType.vim" as TT

type Token = Tok.Token
type TokenType = TT.TokenType

var keywords: dict<TokenType> = {
    "and":    TokenType.AND,
    "class":  TokenType.CLASS,
    "else":   TokenType.ELSE,
    "false":  TokenType.FALSE,
    "for":    TokenType.FOR,
    "fun":    TokenType.FUN,
    "if":     TokenType.IF,
    "nil":    TokenType.NIL,
    "or":     TokenType.OR,
    "print":  TokenType.PRINT,
    "return": TokenType.RETURN,
    "super":  TokenType.SUPER,
    "this":   TokenType.THIS,
    "true":   TokenType.TRUE,
    "var":    TokenType.VAR,
    "while":  TokenType.WHILE,
}

export class Scanner
    const _source:  string
    final _tokens:  list<Token> = []
    var   _start:   number = 0
    var   _current: number = 0
    var   _line:    number = 1

    def new(source: string)
        this._source = source
    enddef

    def ScanTokens(): list<Token>
        while !this._IsAtEnd()
            # We are at the beginning of the next lexeme.
            this._start = this._current
            this._ScanToken()
        endwhile

        this._tokens->add(Token.new(TokenType.EOF, "", null, this._line))
        return this._tokens
    enddef

    def _ScanToken(): void
        var c = this._Advance()

        if c == "(" 
            this._AddToken(TokenType.LEFT_PAREN)
        elseif c == ")"
            this._AddToken(TokenType.RIGHT_PAREN)
        elseif c == "{"
            this._AddToken(TokenType.LEFT_BRACE)
        elseif c == "}"
            this._AddToken(TokenType.RIGHT_BRACE)
        elseif c == ","
            this._AddToken(TokenType.COMMA)
        elseif c == "."
            this._AddToken(TokenType.DOT)
        elseif c == "-"
            this._AddToken(TokenType.MINUS)
        elseif c == "+"
            this._AddToken(TokenType.PLUS)
        elseif c == ";"
            this._AddToken(TokenType.SEMICOLON)
        elseif c == "*"
            this._AddToken(TokenType.STAR)

        elseif c == "!"
            this._AddToken(this._Match("=") ? TokenType.BANG_EQUAL : TokenType.BANG)
        elseif c == "="
            this._AddToken(this._Match("=") ? TokenType.EQUAL_EQUAL : TokenType.EQUAL)
        elseif c == "<"
            this._AddToken(this._Match("=") ? TokenType.LESS_EQUAL : TokenType.LESS)
        elseif c == ">"
            this._AddToken(this._Match("=") ? TokenType.GREATER_EQUAL : TokenType.GREATER)

        elseif c == "/"
            if this._Match("/")
                # A comment goes until the end of the line.
                while this._Peek() != "\n" && !this._IsAtEnd()
                    this._Advance()
                endwhile
            else
                this._AddToken(TokenType.SLASH)
            endif
        elseif c == " " || c == "\r" || c == "\t"
            # Ignore whitespace.
        elseif c == "\n"
            ++this._line

        elseif c == '"'
            this._String()
        else
            if this._IsDigit(c)
                this._Number()
            elseif this._IsAlpha(c)
                this._Identifier()
            else
                Common.Error(this._line, $"Unexpected character {c}.")
            endif
        endif
    enddef

    def _IsAtEnd(): bool
        return this._current >= strlen(this._source)
    enddef

    def _Advance(): string
        ++this._current
        return this._source[this._current - 1]
    enddef

    def _Peek(): string
        if this._IsAtEnd()
            return "\0"
        endif
        return this._source[this._current]
    enddef

    def _PeekNext(): string
        if this._current + 1 >= strlen(this._source)
            return "\0"
        endif
        return this._source[this._current + 1]
    enddef

    def _Match(expected: string): bool 
        if this._IsAtEnd()
            return false
        endif
        if this._source[this._current] != expected
            return false
        endif
        ++this._current
        return true
    enddef

    def _AddToken(type: TokenType, literal: any = null): void
        var text = slice(this._source, this._start, this._current)
        this._tokens->add(Token.new(type, text, literal, this._line))
    enddef

    def _Number(): void
        while this._IsDigit(this._Peek())
            this._Advance()
        endwhile

        # Look for a fractional part.
        if this._Peek() == "." && this._IsDigit(this._PeekNext())
            # Consumen the ".".
            this._Advance()
            while this._IsDigit(this._Peek())
                this._Advance()
            endwhile
        endif

        this._AddToken(TokenType.NUMBER, str2nr(slice(this._source, this._start, this._current)))
    enddef

    def _String(): void
        while this._Peek() != '"' && !this._IsAtEnd()
            if this._Peek() == "\n"
                ++this._line
            endif
            this._Advance()
        endwhile

        if this._IsAtEnd()
            Common.Error(this._line, "Unterminated string.")
        endif

        # The closing ".
        this._Advance()

        # Trim the surrounding quotes.
        var value = slice(this._source, this._start + 1, this._current - 1)
        this._AddToken(TokenType.STRING, value)
    enddef

    def _Identifier(): void
        while this._IsAlphaNumeric(this._Peek())
            this._Advance()
        endwhile

        var text = slice(this._source, this._start, this._current)
        if has_key(keywords, text)
            this._AddToken(keywords[text])
        else
            this._AddToken(TokenType.IDENTIFIER)
        endif
    enddef

    def _IsDigit(c: string): bool
        return c >= "0" && c <= "9"
    enddef

    def _IsAlpha(c: string): bool
        return (c >= "a" && c <= "z") ||
               (c >= "A" && c <= "Z") ||
               c == "_"
    enddef

    def _IsAlphaNumeric(c: string): bool
        return this._IsAlpha(c) || this._IsDigit(c)
    enddef
endclass

if !exists("g:vimlox_production")
    defc
endif
