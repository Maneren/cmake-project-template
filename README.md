# CMake C++ Project Template with Google-Test Unit Testing Library

## Division with a remainder library

Are you just starting with `CMake` or C++?

Do you need some easy-to-use starting point, but one that has the basic moving
parts you are likely going to need on any medium sized project?

Do you believe in test-driven development, or at the very least — write your
tests _together_ with the feature code? If so you'd want to start your project
pre-integrated with a good testing framework.

Divider is a minimal project that's kept deliberately very small. When you build
it using CMake/make (see below) it generates:

1. A tiny **static library** `lib/libdivision.a`,
2. **A command line binary `bin/divider`**, which links with the library,

## Usage

### Prerequisites

You will need:

- A modern C/C++ compiler
- CMake 3.10+ installed (on a Mac, run `brew install cmake`)

### Building The Project

#### Git Clone

First we need to check out the git repo:

```bash
❯ mkdir ~/workspace
❯ cd ~/workspace
❯ git clone \
    https://github.com/Maneren/cmake-project-template \
    my-project
❯ cd my-project
```

then either install GoogleTest from your favorite package manager (preferably)
or fetch the git submodule:

```bash
❯ git submodule update --init
```

#### Project Structure

There are three empty folders: `lib`, `bin`, and `include`. Those are populated
by `cmake` when you run `--install`.

The rest should be obvious: `src` is for the source files, and `test` is where
we put our unit tests.

Now we can build this project, and below we show three separate ways to do so.

#### Building

```bash
❯ just configure
❯ cd build
❯ cmake ..
❯ make && make install
❯ cd ..
```

There is a Just file that simplifies this process.

```bash
❯ just configure install
```

#### Running the tests

```bash
❯ cd build && ctest
    Start 1: DividerTest.5_DivideBy_2
1/5 Test #1: DividerTest.5_DivideBy_2 .........   Passed    0.00 sec
    Start 2: DividerTest.9_DivideBy_3
2/5 Test #2: DividerTest.9_DivideBy_3 .........   Passed    0.00 sec
    Start 3: DividerTest.17_DivideBy_19
3/5 Test #3: DividerTest.17_DivideBy_19 .......   Passed    0.00 sec
    Start 4: DividerTest.Long_DivideBy_Long
4/5 Test #4: DividerTest.Long_DivideBy_Long ...   Passed    0.00 sec
    Start 5: DividerTest.DivisionByZero
5/5 Test #5: DividerTest.DivisionByZero .......   Passed    0.00 sec

100% tests passed, 0 tests failed out of 5

Total Test time (real) =   0.01 sec
```

Again, with Just it's a one-liner:

```bash
❯ just test
```

#### Running the CLI Executable

Without arguments, it prints out its usage:

```bash
❯ bin/divider

Divider © 2018 Monkey Claps Inc.

Usage:
    divider <numerator> <denominator>

Description:
    Computes the result of a fractional division,
    and reports both the result and the remainder.
```

But with arguments, it computes as expected the denominator:

```bash
❯ bin/divider 112443477 12309324

Divider © 2018 Monkey Claps Inc.

Division : 112443477 / 12309324 = 9
Remainder: 112443477 % 12309324 = 1659561
```

And lastly, with Just it's again as simple as:

```bash
❯ just run Debug 112443477 12309324
```

(Debug is the CMake build type, so it can be also Release, RelWithDebInfo or MinSizeRel.)

### Using it as a C++ Library

We build a static library that, given a simple fraction will return the integer
result of the division, and the remainder.

We can use it from C++ like so:

```cpp
#include <division/division.h>
#include <iostream>

const auto f = division::Fraction{25, 7};
const auto r = division::Division(f).divide();

std::cout << "Result of the division is " << r.division;
std::cout << "Remainder of the division is " << r.remainder;
```

## File Locations

- `src/*` — C++ code that ultimately compiles into a library
- `test/external` — C++ libraries used for tests (e.g. Google Test)
- `test/src` — C++ test suite
- `bin/`, `lib`, `include` are all empty directories, until the `make install`
  install the project artifacts there.

Tests:

- A `test` folder with the automated tests and fixtures that mimics
  the directory structure of `src`.
- For every C++ file in `src/A/B/<name>.cpp` there is a corresponding
  test file `test/A/B/<name>_test.cpp`

## License

&copy; 2017-2019 Konstantin Gredeskoul. 2025-present Maneren

Open sourced under MIT license, the terms of which can be read here — [MIT License](http://opensource.org/licenses/MIT).

## Acknowledgements

This project is a derivative of the [CMake Tutorial](https://cmake.org/cmake-tutorial/),
and is aimed at saving time for starting new projects in C++ that use CMake and GoogleTest.
