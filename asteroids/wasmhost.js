import { OutputStream } from './stream.js';
import { VectorDisplay } from './vector_display.js';

export class WasmHost {
    constructor(wasm_url, canvas) {
        this.wasm_url = wasm_url;
        this.wasm_instance = null;
        this.wasm_module = null;
        this.stdout = new OutputStream();
        this.timer_id = null;
        this.timer_last_invoked = null;
        this.vector_display = new VectorDisplay(canvas);
        // "Imports" is relative to the wasm instance:
        // Things being imported into the wasm instance from this host.
        this.imports = {
            env: {
                sys_putc_int: this.stdout.putc_int,
                sys_timer_request: this.sys_timer_request,
                sys_timer_cancel: this.sys_timer_cancel,
            }
        };
        // Exports from module to host:
        // sys_timer_expired(float elapsed_milliseconds)
        // sys_init()
    }

    async start() {
        var response = await fetch(this.wasm_url);
        var wasmBytes = await response.arrayBuffer();
        var instance_source = await WebAssembly.instantiate(wasmBytes, this.imports);
        this.wasm_instance = instance_source.instance;
        this.wasm_module = instance_source.module;
        document.getElementById('output').textContent = this.wasm_instance.exports.sys_init();

        var v = this.vector_display;
        v.gun(0);
        v.move_to(0,0);
        v.gun(1);
        for (var x = 0; x < 100; x += 20) {
            v.move_to(x, 0);
            v.move_to(x, 20);
        }
        v.gun(0);
        v.move_to(30,30);
        v.gun(1)
        v.move_to(60,60);
        v.gun(0);
        v.move_to(60,30);
        v.gun(1)
        v.move_to(30,60);
        v.render();
    }

    // Import functions
    // These methods are imported into the wasm module.
    sys_timer_request = (period_milliseconds) => {
        console.log(`Timer requested ${period_milliseconds}ms`);
        this.timer_id = setInterval(this._timer_expired, period_milliseconds);
    }

    _timer_expired = () => {
        var now = new Date();
        var elapsed = this.timer_last_invoked ? now - this.timer_last_invoked : 0;
        this.timer_last_invoked = now;
        this.wasm_instance.exports.sys_timer_expired(elapsed);
    }

    sys_timer_cancel = () => {
        if (!this.timer_id)
            return;
        clearInterval(this.timer_id);
        this.timer_id = null;
        this.timer_last_invoked = null;
    }
}
