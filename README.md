# CMake C++ Project Template with Google-Test Unit Testing Library

Are you just starting with `CMake` or C++?

Do you need some easy-to-use starting point, but one that has the basic moving
parts you are likely going to need on any medium sized project?

Do you believe in test-driven development, or at the very least — write your
tests _together_ with the feature code? If so you'd want to start your project
pre-integrated with a good testing framework.

## Division with a remainder library

Divider is a minimal project that's kept deliberately small. It is used to
showcase various parts of the CMake template. When you build it using CMake/make
(see below) it generates:

1. A tiny **static library** `lib/libdivision.a`,
2. **A command line binary `bin/divider`**, which links with the library,

## Using the template

### Prerequisites

You will need:

- A modern C++ compiler in the `CXX` environment variable
- [`cmake`](https://cmake.org/) version 3.25+
- optionally also the [`just`](https://github.com/casey/just) command runner

### Git Clone

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

### Project Structure

The project source files are split into 3 folders:

- `src` contains the library code
  - here should be the bulk of the logic, classes, etc.
- `apps` contains the application code
  - here should be the frontend and the main function
- `test` contains the tests

More on specific subfolders in [[#project-structure]].

### Building

```bash
❯ mkdir build
❯ cd build
❯ cmake ..
❯ make && make install
❯ cd ..
```

There is a Justfile that simplifies this process. It uses (opinionated)
recommended defaults – Ninja Multi-Config generator and clang++ compiler.

```bash
❯ just configure
❯ just build [Debug|Release|RelWithDebInfo|MinSizeRel] [target]
```

### Running the tests

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

### Running the CLI Executable

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
❯ build/bin/Debug/divider 112443477 12309324

Divider © 2018 Monkey Claps Inc.

Division : 112443477 / 12309324 = 9
Remainder: 112443477 % 12309324 = 1659561
```

And lastly, with Just it's again as simple as:

```bash
❯ just run [Debug|Release|RelWithDebInfo|MinSizeRel] [...args]
```

Debug is the CMake build type, so it can be also Release, RelWithDebInfo or
MinSizeRel.

### Using it as a C++ Library

We build a static library that, given a simple fraction will return the integer
result of the division, and the remainder.

We can use it from C++ like so:

```cpp
#include <division/division.h>
#include <iostream>

const auto f = division::Fraction{.numerator = 25, .denominator = 7};
const auto r = division::Division(f).divide();

std::cout << "Result of the division is " << r.division;
std::cout << "Remainder of the division is " << r.remainder;
```

## File Locations

- `src` – library code
  - `external` – external libraries
  - `*` – individual project libraries
    - `src` – private source files
    - `include/*` – public headers
- `apps` - aapplication code
  - `*` - individual project applications
    - `src` - source files
- `test`
  - `external` – external libraries used for tests (e.g. Google Test)
  - `unit` – unit tests
    - `*` – unit tests for each library
      - `**/*.cpp` – should mirror corresponding source files
    - `CMakeLists.txt` – add unit tests to this file
  - `*` – other test types (e.g. integration, end-to-end, etc.)
    - structure should mirror that of `test/unit`
    - add this subfolder to `test/CMakeLists.txt`

Read through the sample divider project to understand the details.

## License

&copy; 2017-2019 Konstantin Gredeskoul. 2025-present Maneren

Open sourced under MIT license, the terms of which can be read here — [MIT License](http://opensource.org/licenses/MIT).

## Acknowledgements

This project is a derivative of the [CMake Tutorial](https://cmake.org/cmake-tutorial/),
and is aimed at saving time for starting new projects in C++ that use CMake and GoogleTest.
