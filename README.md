# CMake C++ Project Template with Google-Test Unit Testing Library

Are you just starting with `CMake` or C++?

Do you need some easy-to-use starting point, but one that has the basic moving
parts you are likely going to need on any medium sized project?

Do you believe in test-driven development, or at the very least — write your
tests _together_ with the feature code? If so you'd want to start your project
pre-integrated with a good testing framework.

> [!NOTE]
>
> This template is mainly focused on Unix-like systems. It should work on
> Windows as well, but it is not guaranteed.

This template is maintained in two variants:

- `main` – traditional headers (`src/*/include`, `#include`), works with any
  recent compiler.
- `modules` – C++20/23 named modules (`.cppm` + `import`), requires CMake
  3.31+, Ninja, and a compiler with module + `import std` support
  (e.g. GCC 16+).

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
- [`cmake`](https://cmake.org/) version 3.31+
- [`ninja`](https://ninja-build.org/) (required for the default
  `Ninja Multi-Config` generator)
- optionally, it's recommended to also have
  - the [`just`](https://github.com/casey/just) command runner

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

GoogleTest is picked up automatically: a system installation is used when
available, otherwise it is fetched with CMake's `FetchContent`
(see `src/external/gtest/CMakeLists.txt`). No manual steps are needed.

### Project Structure

The project source files are split into 3 folders:

- `src` contains the library code
  - here should be the bulk of the logic, classes, etc.
- `apps` contains the application code
  - here should be the frontend and the main function
- `test` contains the tests

More on specific subfolders in [[#project-structure]].

### Building

Building is done with CMake in two steps:

1. Configure

   ```bash
   mkdir build
   cd build
   cmake ..
   ```

2. Build

   (still in the `build` folder)

   ```bash
   make
   ```

There is a Justfile that simplifies this process. It uses (opinionated)
recommended defaults – Ninja Multi-Config generator and clang++ compiler
(those can be overridden in the Justfile).

```bash
just configure
just build [Debug|Release|RelWithDebInfo|MinSizeRel] [target]
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
just test
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
just run [Debug|Release|RelWithDebInfo|MinSizeRel] [...args]
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

### Adding new parts

The template automatically recognizes new files and subfolders with source files
but when adding a more significant part of the project, like a new application
or library (both internal and external), you have to reconfigure the project.

This is done similarly to the initial build:

```bash
cd build
cmake ..
```

or with Just:

```bash
just configure
```

### Clean build

When encountering issues with CMake or compilation, first try clean building:

```bash
rm -rf build
mkdir build
cd build
cmake ..
```

or

```bash
just clean configure
```

## File Locations

- `src` – library code
  - `external` – external libraries
  - `*` – individual project libraries
    - `src` – private source files
    - `include/*` – public headers
- `apps` - application code
  - `*` - individual project applications
    - `src` - source files
- `test`
  - `unit` – unit tests
    - `*` – unit tests for each library
      - `**/*.cpp` – should mirror corresponding source files
    - `CMakeLists.txt` – add unit tests to this file
  - `*` – other test types (e.g. integration, end-to-end, etc.)
    - structure should mirror that of `test/unit`
    - add this subfolder to `test/CMakeLists.txt`
- `cmake` – CMake helpers
  - `LibraryTemplate.cmake` – `create_library` / `auto_create_library`
  - `ExecutableTemplate.cmake` – `create_executable` / `auto_create_executable`
  - `TestTemplate.cmake` – `create_test_executable` (GoogleTest based)
  - `CommonUtils.cmake` – shared compiler/linker flags and helpers

Read through the sample divider project to understand the details.

## Flags

The template by default sets the following compiler flags
(see `cmake/CommonUtils.cmake`):

- for all build configurations
  - `-std=c++<CXX_STD>` (`CXX_STD` is set per target, 23 in this template) –
    specify C++ standard
  - `-Wall -Wextra -Wpedantic -Wconversion` – enable as many warnings as
    possible
- for `Debug` build configuration
  - `-Og` – enable a few optimizations that improve debug information
  - optionally `-fsanitize=address,undefined,leak` when configured with
    `-DSANITIZERS=ON` (modern replacement for `valgrind` memcheck)
- for `Debug` and `RelWithDebInfo` build configurations
  - `-g3 -gdwarf-5` – enable debug information in the Dwarf format
  - `-fno-omit-frame-pointer` – enable frame pointer for better debugging
- for `Release` and `RelWithDebInfo` build configurations
  - `-O3` – enable aggressive optimizations

Interprocedural optimization (LTO) is enabled by default via
`CMAKE_INTERPROCEDURAL_OPTIMIZATION` (disable with `-DUSE_IPO=OFF`).
Libraries are created as thin archives by default (disable with
`-DTHIN_ARCHIVE=OFF`). `ccache`/`sccache` support is available with
`-DUSE_CCACHE=ON`.

You can add additional flags with `CMAKE_CXX_FLAGS` or
`CMAKE_CXX_FLAGS_${BUILD_TYPE}` and other common environment variables.

For more info see the `cmake/CommonUtils.cmake` file, where they are set, and
`build/compile_commands.json`, where the effective compilation commands are.

## CMake helper interface

Libraries, executables and tests are declared through small wrappers:

```cmake
# src/<lib>/CMakeLists.txt — sources/headers are globbed automatically
auto_create_library(<lib>
  STATIC|SHARED|OBJECT|INTERFACE  # default: static
  CXX_STD <std>                   # e.g. 23; no global default
  PRIVATE_DEPS <libs...>          # link privately
  PUBLIC_DEPS <libs...>           # link publicly
  INTERFACE_DEPS <libs...>        # header-only deps
)

# apps/<app>/CMakeLists.txt
auto_create_executable(<app>
  DEPENDS <libs...>
  CONSOLE|GUI
  OUTPUT_NAME "<name>"
  VERSION <version>
  CXX_STD <std>
)

# test/unit/CMakeLists.txt
create_test_executable(<name_tests>
  SOURCES <dir>/<tests>.cpp
  DEPENDS <libs...>
  CXX_STD <std>
)
add_dependencies(all_tests <name_tests>)
```

Public headers live in `src/<lib>/include/` and are attached with
`FILE_SET HEADERS`, so consumers automatically get the right include paths.

## Formatting

C++ sources follow the LLVM-based `.clang-format` style, CMake files are
formatted with [gersemi](https://github.com/BlankSpruce/gersemi). Run both
with:

```bash
just format
```

which executes `clang-format -i` on the sources and
`gersemi -i . --definitions cmake --no-cache` on the CMake files.

## License

&copy; 2017-2019 Konstantin Gredeskoul. 2025-present Maneren

Open sourced under MIT license, the terms of which can be read here — [MIT License](http://opensource.org/licenses/MIT).

## Acknowledgements

This project is a derivative of the [CMake Tutorial](https://cmake.org/cmake-tutorial/),
and is aimed at saving time for starting new projects in C++ that use CMake and GoogleTest.
