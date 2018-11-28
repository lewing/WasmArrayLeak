TOP=$(realpath $(CURDIR))

#Use either ' ' or '--debugrt' dependending on what you need
DRIVER_CONF=--debugrt
#DRIVER_CONF=

#Use either 'release' or 'debug' dependending on what you need
DOM_CONF=debug

# WASM_SDK=$(TOP)/mono/sdks
# WASM_SDK_FRAMEWORK=$(WASM_SDK)/framework
# WASM_SDK_PACKAGER=$(WASM_SDK)
   WASM_SDK=$(TOP)../../projects/mono/sdks/out/wasm-bcl/wasm
   WASM_SDK_FRAMEWORK=$(TOP)../../projects/mono/sdks/wasm
   WASM_SDK_PACKAGER=$(TOP)/../../projects/mono/sdks/wasm

APP_SOURCES = \
	./Hello.cs

ASSETS = \
    --asset=index.html   \

$(TOP)/mono/:
	mkdir -p $@

.stamp-wasm-bcl: | $(TOP)/mono/
	curl -L 'https://jenkins.mono-project.com/job/test-mono-mainline-wasm/1453/label=ubuntu-1804-amd64/Azure/processDownloadRequest/1453/ubuntu-1804-amd64/sdks/wasm/mono-wasm-aa50145d121.zip' -o "mono-wasm.zip" -#
	unzip mono-wasm.zip -d $(TOP)/mono/sdks
	touch $@

.PHONY: wasmbcl
wasmbcl: .stamp-wasm-bcl

WasmArrayLeak.dll: Program.cs
	msbuild WasmArrayLeak.csproj /p:configuration=$(DOM_CONF)

gen-runtime:
	mono $(WASM_SDK_PACKAGER)/packager.exe ${DRIVER_CONF} --copy=ifnewer --out=publish --prefix=./bin/Debug/netstandard2.0 ${ASSETS} WasmArrayLeak.dll


build-managed: WasmArrayLeak.dll gen-runtime

build: wasmbcl build-managed

clean:
	rm -rf publish
