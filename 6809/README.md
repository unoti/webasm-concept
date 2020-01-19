# Motorola 6809 Assembly

## Goal
Create a 6809-based machine which has a serial port, and write an 'R' to the serial port.  We'll host that in our proof-of-concept web testbed, and get an 'R' to print to the screen in the web browser.

## Architecture
* **Web browser** This will host our index.html and main.js, which will load and execute  the wasm module.
* **Wasm Module**.  The WASM module this time will be a 6809 emulator.  I haven't decided yet if I'm going to use one written in C or javascript.
* **6809 ROM**.  We'll create a ROM file using a cross assembler.  This will be loaded into the wasm module.

We need to get a 6809 cross assembler going. We considered using http://www.6809.org.uk/git/asm6809.git/.  But decided to try (wla-dx)[https://github.com/vhelin/wla-dx] first.  That's because if we can get wla-dx working it'll support a variety of different cpu's including 6502, z80, 6809, and 8080.


## Our 6809 virtual machine
Our machine will have an io output port attached at $E000. When we write bytes there they will be output
to the external world.

## Compile the Cross-Assembler

From your real machine, go into the ```local``` directory.

```
cd local
git clone https://github.com/vhelin/wla-dx
cd wla-dx
```

Now from your Linux container:
```
apt-get install cmake
cd /code/local/wla-dx
mkdir build
cd build
cmake .. # Generate build system
cmake --build . --config Release # Build it
cmake -P cmake_install.cmake # Install it
```

Documentation is included in the source, but I found this online:
[WLA-DX Documentation](https://readthedocs.org/projects/wla-dx/downloads/pdf/latest/)

## Compile the emulator library
From your real machine, go into the ```local``` directory.

```
cd local
git clone https://github.com/spc476/mc6809
```

Then go to your Linux container:
```
cd local/mc6809
make
ls -l /code/local/mc6809/mc09emulator
```
And there's your 6809 emulator!

## Assemble wla-dx-example
To verify our assembler works we'll assemble the 6809/wla-dx-example.

From the Linux container:
```
cd /code/6809/wla-dx-example
make
ls -ls
```
You should see something like:
```
root@2233d6907e98:/code/6809/wla-dx-example# ls -l
total 79
-rwxr-xr-x 1 root root   390 Jan 19 20:37 Makefile
-rwxr-xr-x 1 root root  1097 Jan 19 20:38 library.lib
-rwxr-xr-x 1 root root  1628 Jan 19 20:37 library.s
-rwxr-xr-x 1 root root 65536 Jan 19 20:38 linked.rom
-rwxr-xr-x 1 root root   603 Jan 19 20:38 linked.sym
-rwxr-xr-x 1 root root    59 Jan 19 20:36 linkfile
-rwxr-xr-x 1 root root   499 Jan 19 20:38 main.o
-rwxr-xr-x 1 root root  1263 Jan 19 20:36 main.s
```

You can also do:
```
root@2233d6907e98:/code/6809/wla-dx-example# hexdump -C linked.rom
00000000  00 02 30 31 3e 3a c9 12  e9 e4 e9 e6 e9 e5 e9 e0  |..01>:..........|
00000010  e9 e1 e9 e2 e9 e3 e9 f4  e9 f6 e9 f5 e9 fb e9 f1  |................|
00000020  e9 f3 e9 f8 12 e9 f9 12  34 e9 9c 12 e9 9d 12 34  |........4......4|
00000030  e9 9f 12 34 e9 61 e9 e8  66 e9 e9 12 34 e9 8c 12  |...4.a..f...4...|
00000040  e9 8d 12 34 d9 1f f9 12  34 3c 30 31 20 30 32 3e  |...4....4<01 02>|
00000050  1e 89 1e ab 1e 05 1e 12  1e 34 3c 30 32 20 30 33  |.........4<02 03|
00000060  3e 24 fe 25 fc 27 fa 2c  04 2e 02 22 00 3c 30 33  |>$.%.'.,...".<03|
00000070  20 30 34 3e 6e 88 ea 6e  89 00 61 0e 61 3c 30 34  | 04>n..n..a.a<04|
00000080  3e 20 30 35 3e 10 ce d9  10 ee 88 d5 10 de 61 10  |> 05>.........a.|
00000090  fe 00 61 3c 30 35 20 30  36 3e a7 88 c4 97 61 b7  |..a<05 06>....a.|
000000a0  00 61 3c 30 36 20 30 37  3e 34 ff 36 40 35 ff 37  |.a<06 07>4.6@5.7|
000000b0  40 3c 30 37 20 30 38 3e  1f 89 1f ab 1f 05 1f 12  |@<07 08>........|
000000c0  1f 34 3c 30 38 20 30 39  3e 3f 3f 10 3f 11 3f 3c  |.4<08 09>??.?.?<|
000000d0  30 39 20 31 30 3e 10 24  ff fc 10 25 ff f8 10 27  |09 10>.$...%...'|
000000e0  ff f4 10 2c 00 08 10 2e  00 04 10 22 00 00 3c 31  |...,......."..<1|
000000f0  30 aa aa aa aa aa aa aa  aa aa aa aa aa aa aa aa  |0...............|
00000100  aa aa aa aa aa aa aa aa  aa aa aa aa aa aa aa aa  |................|
*
00001000  41 41 3e 3c 41 41 20 42  42 3e 3c 42 42 aa aa aa  |AA><AA BB><BB...|
00001010  aa aa aa aa aa aa aa aa  aa aa aa aa aa aa aa aa  |................|
*
00010000
```

Ok this looks good.

[6809 Opcodes Reference](https://www.maddes.net/m6809pm/appendix_d.htm)

I'm pretty sure the disassembler doesn't work right for all opcodes.  But here's how to use it anyway.

```
/code/local/mc6809/mc09disasm linked.rom {load_at} {start_at}
```
So to start disassembling at address $9a, do this:
```
/code/local/mc6809/mc09disasm linked.rom 0 9a
```

/code/local/mc6809/mc09emulator linked.rom 0

## Assemble sayhello
```
cd /code/6809/sayhello
make
ls -l linked.rom
hexdump -C linked.rom
```
You'll see:
```
root@2233d6907e98:/code/6809/sayhello# hexdump -C linked.rom
00000000  aa aa aa aa aa aa aa aa  aa aa aa aa aa aa aa aa  |................|
*
0000f000  86 52 97 00 86 49 97 01  86 43 97 02 86 4f 97 03  |.R...I...C...O..|
0000f010  aa aa aa aa aa aa aa aa  aa aa aa aa aa aa aa aa  |................|
*
0000fff0  aa aa aa aa aa aa aa aa  aa aa aa aa aa aa f0 00  |................|
00010000
```
Note that our executable code starts at $f000 as we expect looking at main.s.
Also note that the 2 bytes at $fffe are the vector to the start of our code ($f000).

We're using a 64kb output rom.  It's possible to set the linker and source files up such that you just have a smaller file that represents what you'd burn to a rom, say a 4kb or 2kb file, but a full 64kb file is fine for now.

Note that the memory at 0 is filled with $AA.

## Execute sayhello in the 6809 emulator.
From the Linux container:
```bash
cd /code/6809/sayhello
# The 0 here is to tell the emulator to load our rom image at address 0.
/code/local/mc6809/mc09emulator linked.rom 0
```
It will execute our code, then crash when it gets to undefined instructions after our code.  It them produces a dump of what our memory looked like at the end into the file ```mc6809-core```.
```bash

```
