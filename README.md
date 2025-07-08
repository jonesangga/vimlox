# vimlox

An implementation of Lox tree-walk interpreter from [Crafting Interpreters](https://craftinginterpreters.com/)
in vim9script.

Status: WIP.

## Installation

Install using Vim's builtin package manager:

```
mkdir -p ~/.vim/pack/vimlox/start
git clone --depth 1 https://github.com/jonesangga/vimlox ~/.vim/pack/vimlox/start/vimlox
```

## Usage

For now use `:Vimlox <source code>`. For example

```
:Vimlox 1 + 2 * 3 + (4 - 5)
```
