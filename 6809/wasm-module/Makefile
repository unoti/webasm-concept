
hi.wasm: hi.c
	clang --target=wasm32 -nostdlib -Wl,--no-entry -Wl,--export-all \
	-Wl,--allow-undefined \
	-o hi.wasm hi.c

clean :
	rm --force hi.wasm
