vim9script

import autoload "../autoload/Lox.vim"

# This is to execute :defc in every module.
# Uncomment this for development. Comment this before commit.
# g:vimlox_development = 1

command! -nargs=1 Vimlox Lox.Run(<q-args>)
