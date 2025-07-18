# vimlox

An implementation of Lox tree-walk interpreter from [Crafting Interpreters](https://craftinginterpreters.com/)
in vim9script.

Status: WIP.

This does not exactly follow the structure from Crafting Interpreters because vim9script
does not have generic class (yet).

When generic class support added I will continue the `visitor` branch.

## Installation

Install using Vim's builtin package manager:

```
mkdir -p ~/.vim/pack/vimlox/start
git clone --depth 1 https://github.com/jonesangga/vimlox ~/.vim/pack/vimlox/start/vimlox
```

## Usage

For now use `:Vimlox <source code>`. For example

```
:Vimlox var a = 1; var b = 2; print a + b;
```

Later I will add repl support.
