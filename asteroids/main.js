import { WasmHost } from './wasmhost.js';

var host = new WasmHost('./hi.wasm');
host.start();
