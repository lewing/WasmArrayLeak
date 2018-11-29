# WasmArrayLeak
Test cases for array leaks from WebAssembly

To use a wasm build

```

export WASM_SDK=`directory to mono build dir`/mono/sdks/
make clean build

```

or to use the build from jenkins

```

make clean build-sdks

```

This will download sdks zip file from Jenkins, extract it and then build the project.
