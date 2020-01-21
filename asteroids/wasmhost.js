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
                sys_vector_gun: this.vector_display.gun,
                sys_vector_move_to: this.vector_display.move_to,
                sys_vector_render: this.vector_display.render,
                sys_print_num: this.sys_print_num,
                sys_random: this.sys_random,
            }
        };
        // Exports from module to host:
        // sys_timer_expired(float elapsed_milliseconds)
        // main()
    }

    async start() {
        var response = await fetch(this.wasm_url);
        var wasmBytes = await response.arrayBuffer();
        var instance_source = await WebAssembly.instantiate(wasmBytes, this.imports);
        this.wasm_instance = instance_source.instance;
        this.wasm_module = instance_source.module;

        this.wasm_instance.exports.main();
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

    sys_print_num = (n) => {
        console.log(n);
    }

    sys_random = () => {
        return Math.random();
    }
}
