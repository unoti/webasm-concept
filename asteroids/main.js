import { WasmHost } from './wasmhost.js';

var display = document.getElementById('vector-display');
var host = new WasmHost('./asteroids.wasm', display);
host.start();

