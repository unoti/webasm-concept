# webasm-concept
Proof of concept experiments for web assembly plugins for a game.

We want to create a game that involves programming in any language that can create web assembly binaries.  This will include C, C++, Rust, JavaScript.  I'd also like to be able to include assembly languages including 6502 and 6809.

A key component of doing this will be using Web Assembly binaries.  The goal of this repository is to understand how Web Assembly works.

A Web Assembly module is a binary executable that has these characteristics:
* **Module** A binary file that is the image of the executable.  This is akin to a .exe or a .dll, but it's in wasm format.
* **Imports** These are functions that are imported into the module from the host environment.
* **Exports** These are functions that are exported from the module into the host environment.

## Proof of Concept 0
In this proof of concept we'll just host the web assembly in a browser and execute it there.
* Host the wasm module in a web browser
* Import function - output serial bytes to uart.
		Provide host implementation that outputs to console: ```putchar(n)```
* C wasm module that prints your name

## Resources
Understand the basics of WebAssembly:
* [WebAssembly Basic Concepts on MDN](https://developer.mozilla.org/en-US/docs/WebAssembly/Concepts)
* Play with WebAssembly. Good for understanding how imports and exports connect form host to wasm modules
    * https://wasdk.github.io/WasmFiddle/
    * https://webassembly.studio/
* [aransentin.github.io: Notes on working with C and Wasm](https://aransentin.github.io/cwasm/) This is where I learned about --allow-undefined-file and exporting symbols from the host into the wasm module.
* [6809 assembler online](https://www.asm80.com/onepage/asm6809.html)
* [Interacting with JavaScript from WebAssembly](https://medium.com/@MadsSejersen/interacting-with-javascript-from-webassembly-64319b44012e)

## Setup
We're going to set up a dev system in a container with Ubuntu and the Clang compiler.

Downloading and getting the container ready will take a few minutes:
```
docker-compose build
```

Running the container:
```
winpty docker-compose run dev
export PATH=$PATH:/usr/lib/llvm-8/bin #*TODO: get this into the container image
cd /code
```

apt-get install bsdmainutils # For hexdump / hd -- it's in the dockerfile now
apt-get install lld # Is this still needed? yes -- in the dockerfile now

vscode extension dtsvet.vscode-wasm -- preview wasm files by right clicking them

## Running Proof of Concept 0

Build:
From your build container:
```
cd 0-browser-hosting
make
```

Run a web server, from your real host machine:
```
cd 0-browser-hosting
python -m http.server # Runs a web server on port 8000
```

Now open a browser to http://localhost:8000 and you should see "Output: 42"!


## Next Steps
* Linking with stdlib / libc
You'll maybe want to link libc into your asteroids game for sin, cos, and atan2.
To do that, look at these resources:
* [WASI tutorial](https://github.com/bytecodealliance/wasmtime/blob/master/docs/WASI-tutorial.md)
WASI releases a clang that's preconfigured to link stdlib and libc built for WebAssembly, and includes
a runtime library that requires you to explicitly set permissions to files, directories, and other system resources.

* [Compiling C code with WASI](https://00f.net/2019/04/07/compiling-to-webassembly-with-llvm-and-clang/)