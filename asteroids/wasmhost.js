import { OutputStream } from './stream.js';

export class WasmHost {
    constructor(wasm_url) {
        this.wasm_url = wasm_url;
        this.wasm_instance = null;
        this.wasm_module = null;
        this.stdout = new OutputStream();
        // "Imports" is relative to the wasm instance:
        // Things being imported into the wasm instance from this host.
        this.imports = {
            env: {
                uart_write: this.stdout.putc_int,
            }
        };
    }

    async start() {
        var response = await fetch(this.wasm_url);
        var wasmBytes = await response.arrayBuffer();
        var instance_source = await WebAssembly.instantiate(wasmBytes, this.imports);
        this.wasm_instance = instance_source.instance;
        this.wasm_module = instance_source.module;
        document.getElementById('output').textContent = this.wasm_instance.exports.main();
    }
}
