root := justfile_directory()
builddir := root / "build"
export CMAKE_EXPORT_COMPILE_COMMANDS := "1"
export CMAKE_COLOR_DIAGNOSTICS := "ON"

# executable to use for `just run`

executable := "divider"

# Print stdout and stderr on failed tests

export CTEST_OUTPUT_ON_FAILURE := "1"

# Number of threads to use for running tests (0 is auto)

export CTEST_PARALLEL_LEVEL := "0"

[private]
default:
    @just --list

configure build_system="Ninja Multi-Config" +args="": clean
    cmake -B {{ builddir }} -G "{{ build_system }}" -Wno-experimental {{ args }}

build config="Debug" target="all":
    cmake --build {{ builddir }} --config {{ config }} --target {{ target }}

run config="Debug" +args="": (build config executable)
    '{{ builddir }}/bin/{{ config }}/{{ executable }}' {{ args }}

test config="Debug": (build config "tests")

clean:
    rm -rf build

lint:
    clang-tidy -p {{ builddir }} --quiet $(find src apps test -type f \( -name "*.cpp" -or -name "*.h" -or -name "*.hpp" \) -not -path "*/external/*")

format:
    clang-format -i $(find src apps test -type f \( -name "*.cpp" -or -name "*.h" -or -name "*.hpp" \) -not -path "*/external/*")
    gersemi -i . --definitions cmake --no-cache
