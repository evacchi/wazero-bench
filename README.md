# wazero benchmark runner

Requirements:

- zig 0.11.0 in PATH
- source code to zig 0.11.0
- TinyGo in PATH
- Go in PATH

First, build the test suite:

    make zigroot=/path/to/zig/source

Then you can run the test suite against the baseline compiler and the optimizing compiler; e.g.:

    go test -bench=. --benchtime=1x

