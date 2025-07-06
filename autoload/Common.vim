vim9script

export var hadError = false

export def Error(line: number, message: string): void
    Report(line, "", message)
enddef

def Report(line: number, where: string, message: string): void
    echo $"[line {line}] Error{where}: {message}"
    hadError = true
enddef

if exists('g:vimlox_development')
    defc
endif
