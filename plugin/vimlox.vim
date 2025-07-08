vim9script

import autoload "../autoload/Lox.vim"

# This is to execute :defc in every module.
# Comment this for development. Uncomment this before commit.
g:vimlox_production = 1

command! -nargs=1 Vimlox Lox.Run(<q-args>)
