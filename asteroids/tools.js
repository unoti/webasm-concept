import { VectorDisplay } from './vector_display.js';

var display = new VectorDisplay(document.getElementById('vector-preview'));
let asteroid = make_asteroid();
let size = parseInt(document.getElementById('asteroid-size').textContent);
console.log(`size=${size}`);
render_asteroid(display, asteroid, size);
render_asteroid_code(document.getElementById('asteroid-code'), asteroid);
generate_sine_table(document.getElementById('sine-table'));

function generate_sine_table(element) {
    let text = `#define PI ${Math.PI}\n`;

    // Generate 256 values of sine ranging from 0 to 2*PI.
    // Note that the value for table[255] is NOT equal to table[0].
    let segments = 256;
    let delta = Math.PI * 2 / segments;
    text += `#define TWO_PI ${2 * Math.PI}\n`;
    text += `#define PI_BY_2 ${Math.PI/2}\n`;
    text += `#define PI_BY_128 ${delta}\n`
    for (var i=0; i<segments; i++) {
        let angle = i * delta;
        let x = Math.sin(angle);
        text += `${x}, // ${i}\n`;
    }
    element.textContent = text;
}

function make_asteroid() {
    let segments = 10;
    let angle_delta = Math.PI * 2 / segments;
    let points = [];
    // We'll generate an asteroid of radius 1 here then scale it up before rendering.
    for (var i = 0; i < segments; i++) {
        let angle_noise = (Math.random() - 0.5) * 0.5;
        let radius_noise = 0.2 * (Math.random() - 0.5);
        let r = 0.5 + radius_noise;
        let a = angle_delta * i + angle_noise;
        let x = r * Math.cos(a);
        let y = r * Math.sin(a);
    
        points.push([x,y]);
    }
    return points;
}

function transform_pt(point, size) {
    let x = point[0] * size + size;
    let y = point[1] * size + size;
    return [x, y];
}

function render_asteroid(display, points, size) {
    display.gun(0);
    let start_pt = transform_pt(points[0], size);
    display.move_to(start_pt[0], start_pt[1]);
    display.gun(1);
    for (let i=1; i < points.length; i++) {
        let pt = transform_pt(points[i], size);
        display.move_to(pt[0], pt[1]);
    }
    display.move_to(start_pt[0], start_pt[1]);
    display.gun(0);
    display.render();
}

function render_asteroid_code(element, asteroid) {
    var text = "// Model \n";
    for (var i=0; i < asteroid.length; i++) {
        let x = asteroid[i][0];
        let y = asteroid[i][1];
        text += `${x}, ${y},\n`;
    }
    element.textContent = text;
}