# Gomoku-Game
![Tag](https://img.shields.io/github/v/tag/ref-humbold/Gomoku-Game?style=plastic)
![License](https://img.shields.io/github/license/ref-humbold/Gomoku-Game?style=plastic)

Single-player gomoku game in Ocaml

## About
Gomoku is a small single-player (human vs computer) game written in OCaml language. Human player uses white stones and begins each game, whereas computer player uses black stones. Winner is the first player who puts 5 stones of their colour in an unbroken chain either horizontally, vertically or diagonally.

LET'S PLAY GOMOKU!

-----

## Dependencies

### Standard build & run
> *versions last used by the author are in double parentheses and italic*

Build process:
+ Linux-based operating system *((Debian testing))*
+ [OCaml](https://ocaml.org) *((4.08.1))*
+ [Dune](https://dune.build) *((2.7.1))*
+ [GNU Make](https://www.gnu.org/software/make) *((4.3))*

Additional libraries:
+ Graphics *((4.08.1))*

Automated formatting by:
+ Ocamlformat *((0.15))*
+ Ocp-indent *((1.8.1))*

-----

## How to build?
Gomoku can be built using **Dune** with help of **GNU Make**.

Possible Make targets are:
+ `make`, `make all` - same as `make compile`
+ `make compile` - compile source files & link executable
+ `make build` - format source files & compile source files & link executable
+ `make refresh` - remove additional build files & compile source files & link executable

## How to run?
Gomoku can be run directly using the executable file in the `bin` directory:
```sh
$ /path-to-project-directory/bin/gomoku
```
