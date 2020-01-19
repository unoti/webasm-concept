// Returns a buffered output stream writer,
// which is a function you can call to write a single character.
// Output will be buffered until a complete line is ready to write.
// We only need one stream for this application, but this could be called
// multiple times to create multiple streams, such as stdout and stderr.
function output_stream() {
    var buffer = ""; // We'll buffer into this until we see a newline.
    function flush() {
        console.log(buffer);
        buffer = "";
    }
    return {
        putc: function (c_int) {
            if (c_int == 10) { // 10 is '\n'
                flush();
            } else {
                var c = String.fromCharCode(c_int);
                buffer += c;
            }
        },
        flush: flush
    }
}

var stdout = output_stream();

var imports = {
    'env': {
        uart_write: stdout.putc,
    }
};


fetch('./hi.wasm').then(response =>
    response.arrayBuffer()
  ).then(bytes => WebAssembly.instantiate(bytes, imports)).then(results => {
    instance = results.instance;
    document.getElementById("output").textContent = instance.exports.main();
  }).catch(console.error);