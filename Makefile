goroot=$(shell go env GOROOT)
# You should override with the zig source code path.
zigroot?=$(shell dirname $(shell which zig))

zig_bin=testdata/zig
tinygo_bin=testdata/tinygo
gowasip1_bin=testdata/go

tinygo_tests=container/heap \
	container/list \
	container/ring \
	crypto/des \
	crypto/md5 \
	crypto/rc4 \
	crypto/sha1 \
	crypto/sha256 \
	crypto/sha512 \
	embed/internal/embedtest \
	encoding \
	encoding/ascii85 \
	encoding/base32 \
	encoding/csv \
	encoding/hex \
	go/scanner \
	hash \
	hash/adler32 \
	hash/crc64 \
	hash/fnv \
	html \
	internal/itoa \
	internal/profile \
	math \
	math/cmplx \
	net \
	net/http/internal/ascii \
	net/mail \
	os \
	path \
	reflect \
	sync \
	testing \
	testing/iotest \
	text/scanner \
	unicode \
	unicode/utf16 \
	unicode/utf8

gowasip1_tests=src/archive/tar \
	src/bufio \
	src/bytes \
	src/context \
	src/encoding/ascii85 \
	src/encoding/asn1 \
	src/encoding/base32 \
	src/encoding/base64 \
	src/encoding/binary \
	src/encoding/csv \
	src/encoding/gob \
	src/encoding/hex \
	src/encoding/json \
	src/encoding/pem \
	src/encoding/xml \
	src/errors \
	src/expvar \
	src/flag \
	src/fmt \
	src/hash \
	src/hash/adler32 \
	src/hash/crc32 \
	src/hash/crc64 \
	src/hash/fnv \
	src/hash/maphash \
	src/io \
	src/io/fs \
	src/io/ioutil \
	src/log \
	src/log/syslog \
	src/maps \
	src/math \
	src/math/big \
	src/math/bits \
	src/math/cmplx \
	src/math/rand \
	src/mime \
	src/mime/multipart \
	src/mime/quotedprintable \
	src/os \
	src/os/exec \
	src/os/signal \
	src/os/user \
	src/path \
	src/reflect \
	src/regexp \
	src/regexp/syntax \
	src/runtime \
	src/runtime/internal/atomic \
	src/runtime/internal/math \
	src/runtime/internal/sys \
	src/slices \
	src/sort \
	src/strconv \
	src/strings \
	src/sync \
	src/sync/atomic \
	src/syscall \
	src/testing \
	src/testing/fstest \
	src/testing/iotest \
	src/testing/quick \
	src/time

all:
	echo WIP

build.all: build.zig build.tinygo build.gowasip1

.PHONY: build.zig
build.zig:
	mkdir -p $(zig_bin)
	cd $(zigroot) && zig test --test-no-exec -target wasm32-wasi --zig-lib-dir $(zigroot)/lib $(zigroot)/lib/std/std.zig
	cp $(shell find $(zigroot) -name test.wasm) $(zig_bin)/test.wasm
	wasm-opt $(zig_bin)/test.wasm -O --strip-dwarf -o $(zig_bin)/test-opt.wasm

.PHONY: build.tinygo
build.tinygo:
	mkdir -p $(tinygo_bin)
	$(foreach value,$(tinygo_tests),tinygo test -target wasi -c -o ./$(tinygo_bin)/$(subst _,/,$(value)).test $(value);)

.PHONY: build.gowasip1
build.gowasip1:
	mkdir -p $(gowasip1_bin)
	cd $(goroot)
	$(foreach value,$(gowasip1_tests),GOOS=wasip1 GOARCH=wasm && go test -v -c -o ./$(gowasip1_bin)/$(subst /,_,$(value)).test $(goroot)/$(value);)
