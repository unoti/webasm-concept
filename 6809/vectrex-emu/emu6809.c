#include <stdio.h>
#include "e6809.h"

unsigned char memory[65536];

unsigned char memory_read(unsigned address) {
    if (address > 65535) {
        printf("invalid memory read %x\n", address);
        return 0xaa;
    }
    unsigned char b = memory[address];
    printf("mem read [%x] = %02x\n", address, b);
    return b;
}

void memory_write(unsigned address, unsigned char b) {
    if (address > 65535) {
        return;
    }
    printf("mem write [%x] = %02x\n", address, b);
    memory[address] = b;
}

int load_rom(char* filename) {
    FILE *file = fopen(filename, "rb");
    if (!file) {
        return 0;
    }
    fread(memory, 65536, 1, file);
    fclose(file);
    return 1;
}

int dump_memory(char* filename) {
    FILE *file = fopen(filename, "wb");
    if (!file) {
        return 0;
    }
    fwrite(memory, 65536, 1, file);
    fclose(file);
    return 1;
}


// Globals expected by 6809 emulator.
unsigned char (*e6809_read8) (unsigned) = memory_read;
void (*e6809_write8) (unsigned, unsigned char) = memory_write;

int main(int argc, char** argv) {
    if (argc != 2) {
        printf("Usage:\n");
        printf("%s {rom_file}\n", argv[0]);
        return 1;
    }
    char* rom_filename = argv[1];
    int ok = load_rom(rom_filename);
    if (!ok) {
        printf("Unable to load file %s\n", rom_filename);
        return 2;
    }


    e6809_reset();
    unsigned long cycle_count = 0;
    for (;;) {
        printf("cycle=%lu\n", cycle_count);
        int cycles = e6809_sstep(0, 0);
        cycle_count += cycles;
        if (cycle_count > 200)
            break;
    }
    if (!dump_memory("6809-core.bin")) {
        printf("Unable to write core file\n");
    }
    return 0;
}