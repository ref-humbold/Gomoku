# Gomoku-Game
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
+ [OCaml](https://ocaml.org) *((4.08.+))* \
  \[APT package `ocaml`\]
+ [Dune](https://dune.build) *((2.3.+))* \
  \[OPAM package `dune`\]
+ [GNU Make](https://www.gnu.org/software/make) *((4.2.+))* \
  \[APT package `make`\]

Additional libraries:
+ Graphics *((4.08.+))* \
  \[OPAM package `graphics`\]

### Unit testing
+ OUnit2 *((2.2.+))* \
  \[OPAM package `ounit2`\]

### Automated formatting
+ Ocamlformat *((0.13))* \
  \[OPAM package `ocamlformat`\]
+ Ocp-indent *((1.8.+))* \
  \[OPAM package `ocp-indent`\]

-----

## How to build?
Gomoku can be built using **Dune** with help of **GNU Make**.

Possible Make targets are:
+ `make`, `make all` - compile source files & link executable & run unit tests
+ `make compile` - compile source files & link executable
+ `make build` - format source files & compile source files & link executable & run unit tests
+ `make clean` - remove additional build files
+ `make refresh` - remove additional build files & compile source files & link executable & run unit tests
+ `make test` - run unit tests

## How to run?
Gomoku can be run directly using the executable file in the `bin` directory:
```sh
$ /path-to-project-directory/bin/gomoku
```
