H_FILES = sys_host.h micromath.h render.h
C_FILES = asteroids.c micromath.c asteroid_models.c render.c
asteroids.wasm: $(C_FILES) $(H_FILES)
	clang --target=wasm32 -nostdlib -Wl,--no-entry -Wl,--export-all \
	-Wl,--allow-undefined \
	-o asteroids.wasm $(C_FILES)

clean :
	rm --force asteroids.wasm
