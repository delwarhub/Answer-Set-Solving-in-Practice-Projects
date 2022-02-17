# Sudoku

Please modify [sudoku.lp](./sudoku.lp) with your encoding.  
Every time you will push a new commit, your solution will be tested automatically.  
After a few minutes you will be able to see the result of the test in the **Actions** tab.  
You can get more information  about the result of the test by clicking on:
1. The specific test,
2. "Autograding",
3. "Run education/autograding@v1", and 
4. Scrolling down until line ~150.

There, for each instance, you will see if the test is a:
* "success" (correct answer),
* "failure" (wrong answer), 
* "timeout" (no solution found before the time runs out)
* "error" (clingo error).

For each instance, you can find the expected solutions in the [solutions](./solutions) folder.


# Minotaur

Please modify [minotaur.lp](./minotaur.lp) with your encoding.
Every time you will push a new commit, your solution will be tested automatically.
After a few minutes you will be able to see the result of the test in the **Actions** tab.
You can get more information  about the result of the test by clicking on:
1. The specific test,
2. "Autograding",
3. "Run education/autograding@v1", and
4. Scrolling down until line ~150.

There, for each instance, you will see if the test is a:
* "success" (correct answer),
* "failure" (wrong answer),
* "timeout" (no solution found before the time runs out)
* "error" (clingo error).

For each instance, you can find the list of all optimal solutions in the [solutions](./solutions) folder.
Your encoding only need to find one optimal solution.

# Seeknumbers

Please modify [seeknumbers.lp](./seeknumbers.lp) with your encoding.
Every time you will push a new commit, your solution will be tested automatically.
After a few minutes you will be able to see the result of the test in the **Actions** tab.
You can get more information  about the result of the test by clicking on:
1. The specific test,
2. "Autograding",
3. "Run education/autograding@v1", and
4. Scrolling down until line ~150.

There, for each instance, you will see if the test is a:
* "success" (correct answer),
* "failure" (wrong answer),
* "timeout" (no solution found before the time runs out)
* "error" (clingo error).

For each instance, you can find the expected solutions in the [solutions](./solutions) folder.

# Clingo solvers

This repository contains NxN-Sudoku, Yosenabe, Minotaur and Elevator game solvers implemented in [`clingo`](https://github.com/potassco/clingo). The report for the final elevator project can be found [here](./docs/asp_elevator.pdf).

## Dependencies

Install `clingo` onto your system, either via your package manager (recommended, if available) or building from [source](https://github.com/potassco/clingo/blob/master/INSTALL.md).

The source code in this repository was tested against `v5.3.0` of `clingo`.

## Usage

Source code for `clingo` solvers is available in the `src` directory. The `test` directory contains test instances of the respective games.

As an example, one can test the default 9x9 sudoku solver by executing:

```shell
$ clingo ./test/test_sudoku.lp ./src/sudoku.lp 0
```

## Issues

Based on local experiments, all solvers except the Minotaur solver in `minotaur.lp` and/or `minotaur_alternative.lp` succeeded in Yeti benchmark tests. Pull requests for an improved Minotaur solver are therefore very welcome.

## Vim syntax-highlighting

In order to initialize syntax highlighting for `clingo` in `vim`, simply copy the 3 folders inside this repository's `vim` directory into your local `~/.vim` directory.

Source and further information: https://sourceforge.net/p/potassco/code/HEAD/tree/trunk/vim-syntax-gringo/
