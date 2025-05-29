builddir := justfile_directory() / "build"
export CMAKE_EXPORT_COMPILE_COMMANDS := "1"

[private]
default:
    @just --list

configure: clean
    mkdir -p {{ builddir }}
    cmake -G "Ninja Multi-Config" -B {{ builddir }}

build config="Debug":
    cmake --build {{ builddir }} --config {{ config }}

install config="Debug": (build config)
    cmake --install {{ builddir }} --config {{ config }}

clean:
    rm -rf build
