import { VectorDisplay } from './vector_display.js';

var display2 = document.getElementById('vector-preview');
var v = new VectorDisplay(display2);
var segments = 10;
let r = 50;
let angle_delta = Math.PI * 2 / segments;
let x0 = 0;
let y0 = 0;
for (var i = 0; i < segments; i++) {
    let angle_noise = (Math.random() - 0.5) * 0.5;
    let radius_noise = 0.4 * r * (Math.random() - 0.5);
    let a = angle_delta * i + angle_noise;
    let r1 = r + radius_noise;
    let x = r1 * Math.cos(a) + 100;
    let y = r1 * Math.sin(a) + 100;

    v.move_to(x, y);
    if (i == 0) {
        v.gun(1);
        x0 = x;
        y0 = y;
    }
}
v.move_to(x0, y0); // Close it off.
v.gun(1);
v.render();
