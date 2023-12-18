# wazero benchmark runner

## Requirements

- zig 0.11.0 in PATH, source code to zig 0.11.0
- TinyGo in PATH
- Go in PATH

## Usage

First, build the test suite:

    make build.all zigroot=/path/to/zig/source

Then you can run the test suite against the baseline compiler and the optimizing compiler; e.g.:

    go test -bench=. --benchtime=1x

If you want to run with the default settings, use `make`.

## Caveats

* The standard binary zig distribution does not ship some testdata.
  You should override with the zig source code path, otherwise some tests will fail.

* Some tests might fail if Go has been installed with homebrew because
  the file system layout is different than what the tests expect.
  Easiest fix is to install Go without using brew.

