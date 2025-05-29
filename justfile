root := justfile_directory()
builddir := root / "build"
executable := "divider"
export CMAKE_EXPORT_COMPILE_COMMANDS := "1"

[private]
default:
    @just --list

configure build_system="Ninja Multi-Config": clean
    cmake -B {{ builddir }} -G "{{ build_system }}"

build config="Debug" target="all":
    cmake --build {{ builddir }} --config {{ config }} --target {{ target }}

install config="Debug": (build config)
    cmake --install {{ builddir }} --config {{ config }}

run config="Debug" +args="": (install config)
    {{ root }}/bin/{{ executable }} {{ args }}

test config="Debug": (build config "tests")

clean:
    rm -rf build

format:
    clang-format -i $(find src -type f -name "*.cpp" -or -name "*.h")
    clang-format -i $(find test -type f -name "*.cpp" -or -name "*.h" -not -path "*/external/*")
