function uart_write(c) {
    console.log('uart_write '+c);
}

fetch('./hi.wasm').then(response =>
    response.arrayBuffer()
  ).then(bytes => WebAssembly.instantiate(bytes)).then(results => {
    instance = results.instance;
    document.getElementById("output").textContent = instance.exports.main();
  }).catch(console.error);
  