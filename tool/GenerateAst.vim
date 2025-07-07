vim9script

def DefineVisitorNext(text: list<string>, baseName: string, types: list<string>): void
    text->add('export interface VisitorNext')
    for type in types
        var typeName = trim(split(type, "=")[0])
        text->add($"    def Visit{typeName}{baseName}({tolower(baseName)}: {typeName}): string")
    endfor
    text->add('endinterface')
enddef

def DefineAst(baseName: string, types: list<string>): void
    var text: list<string> = []

    text->add("vim9script")
    text->add("")

    text->add('import "./Token.vim" as Tok')
    text->add("type Token = Tok.Token")
    text->add("")

    text->add("export interface Visitor")
    text->add($"    def Visit({tolower(baseName)}: any): string")
    text->add("endinterface")
    text->add("")

    text->add($"export abstract class {baseName}")
    text->add($"    abstract def Accept(visitor: Visitor): string")
    text->add($"endclass")
    text->add("")

    for type in types
        var className = trim(split(type, "=")[0])
        var fields = trim(split(type, "=")[1])
        DefineType(text, baseName, className, fields)
        text->add("")
    endfor

    # This is the Visitor interface that I want to use.
    DefineVisitorNext(text, baseName, types)
    text->add("")

    text->add("if exists('g:vimlox_development')")
    text->add("    defc")
    text->add("endif")

    writefile(text, $"../autoload/{baseName}.vim")
enddef

def DefineType(text: list<string>, baseName: string, className: string, fieldList: string): void
    text->add($"export class {className} extends {baseName}")
    text->add($"    def new({fieldList})")

    # Store parameters in fields.
    var fields = split(fieldList, ", ")
    for field in fields
        var name = split(field, ": ")[0]
        text->add($"        this.{name} = {name}")
    endfor
    text->add("    enddef")
    text->add("")

    # Visitor pattern.
    text->add("    def Accept(visitor: Visitor): string")
    text->add($"        return visitor.Visit(this)")
    text->add("    enddef")
    text->add("")

    # Fields.
    for field in fields
        text->add($"    final {field}")
    endfor

    text->add($"endclass")
enddef

DefineAst("Expr", [
    "Binary   = left: Expr, operator: Token, right: Expr",
    "Grouping = expression: Expr",
    "Literal  = value: any",
    "Unary    = operator: Token, right: Expr",
])

# This is the original.
# DefineAst("", "Expr", [
    # "Binary   : Expr left, Token operator, Expr right",
    # "Grouping : Expr expression",
    # "Literal  : Object value",
    # "Unary    : Token operator, Expr right",
# ])

defc
