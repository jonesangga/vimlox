vim9script

def DefineAst(baseName: string, types: list<string>): void
    var text: list<string> = []

    text->add("vim9script")
    text->add("")

    text->add('import "./Token.vim" as Tok')
    text->add("type Token = Tok.Token")
    text->add("")

    text->add($"export abstract class {baseName}")
    text->add($"endclass")
    text->add("")

    for type in types
        var className = trim(split(type, "=")[0])
        var fields = trim(split(type, "=")[1])
        DefineType(text, baseName, className, fields)
        text->add("")
    endfor

    text->add('if !exists("g:vimlox_production")')
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

DefineAst("Stmt", [
    "Expression = expression: Expr",
    "Print      = expression: Expr"
])

# These are the original.

# defineAst(outputDir, "Stmt", Arrays.asList(
    # "Expression : Expr expression",
    # "Print      : Expr expression"
# ))

# DefineAst("", "Expr", [
    # "Binary   : Expr left, Token operator, Expr right",
    # "Grouping : Expr expression",
    # "Literal  : Object value",
    # "Unary    : Token operator, Expr right",
# ])

defc
