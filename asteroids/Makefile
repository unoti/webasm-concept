asteroids.wasm: asteroids.c
	clang --target=wasm32 -nostdlib -Wl,--no-entry -Wl,--export-all \
	-Wl,--allow-undefined \
	-o asteroids.wasm asteroids.c

clean :
	rm --force asteroids.wasm
