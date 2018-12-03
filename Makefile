TOP=$(realpath $(CURDIR))

#Use either ' ' or '--debugrt' dependending on what you need
DRIVER_CONF=--debugrt
#DRIVER_CONF=

#Use either 'release' or 'debug' dependending on what you need
MANAGE_CONF=debug

WASM_DIR=


ASSETS = \
    --asset=index.html   \
    --asset=NowIsTheTime.txt   \
    --asset=SampleJPGImage_30mbmb.jpg   \


$(TOP)/mono/:
	mkdir -p $@

.stamp-wasm-bcl: | $(TOP)/mono/
	curl -L 'https://jenkins.mono-project.com/job/test-mono-mainline-wasm/1558/label=ubuntu-1804-amd64/Azure/processDownloadRequest/1558/ubuntu-1804-amd64/sdks/wasm/mono-wasm-c99d2de68ef.zip' -o "mono-wasm.zip" -#
	unzip mono-wasm.zip -d $(TOP)/mono/sdks
	touch $@

.PHONY: wasmbcl
wasmbcl: .stamp-wasm-bcl

WasmArrayLeak.dll: Program.cs
	csc /target:library -out:$@ /r:$(WASM_DIR)/System.Net.Http.dll /r:$(WASM_DIR_FRAMEWORK)/WebAssembly.Bindings.dll /r:$(WASM_DIR_FRAMEWORK)/WebAssembly.Net.Http.dll Program.cs 

gen-runtime:
	mono $(WASM_DIR_PACKAGER)/packager.exe ${DRIVER_CONF} --copy=ifnewer --out=publish ${ASSETS} WasmArrayLeak.dll


build-managed: WasmArrayLeak.dll gen-runtime

set_wasm_dir:
	$(eval WASM_DIR=$(WASM_SDK)/out/wasm-bcl/wasm)
	$(eval WASM_DIR_FRAMEWORK=$(WASM_SDK)/wasm)
	$(eval WASM_DIR_PACKAGER=$(WASM_SDK)/wasm)

set_wasm_sdk_dir:
	$(eval WASM_DIR=$(TOP)/mono/sdks/wasm-bcl/wasm)
	$(eval WASM_DIR_FRAMEWORK=$(TOP)/mono/sdks/framework)
	$(eval WASM_DIR_PACKAGER=$(TOP)/mono/sdks)

build: set_wasm_dir build-managed

build-sdks: wasmbcl set_wasm_sdk_dir build-managed

clean:
	rm -rf publish
	rm -f ./WasmArrayLeak.dll
