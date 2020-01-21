#include "asteroids.h"
#include "sys_host.h"
#include "render.h"

struct asteroids_state state;

void write_string(char* s) {
   while (*s) {
      sys_putc_int(*s++);
   }
}

void writeln(char* s) {
   write_string(s);
   sys_putc_int('\n');
}

void print_num(float n) {
   n *= 10;
   for (int i=0; i < n; i++) {
      sys_putc_int('*');
   }
   sys_putc_int('\n');
}

void populate_asteroids(struct asteroids_state* state) {
   unsigned char size = 0;
   int model = 0;
   for (int i=0; i<MAX_ASTEROIDS; i++) {
      int id = ++state->last_id_assigned;
      struct asteroid* a = &state->asteroids[i];
      a->id = id;
      a->active = TRUE;
      a->size = size;
      a->model = get_asteroid_model(model);
      a->pos.x = i * 110 + 50;
      a->pos.y = i * 110 + 50;
      model = (model + 1) % ASTEROID_MODEL_COUNT;
      size = (size + 1) % ASTEROID_SIZE_COUNT;
   }
}

void init_state(struct asteroids_state* state) {
   state->last_id_assigned = 0;
   state->frame_count = 0;
   populate_asteroids(state);
}

/** Called by host when a timer expires. */
void sys_timer_expired(float elapsed_milliseconds) {
   writeln("asteroids.c: Timer called");
   writeln("Cancelling timer");
   sys_timer_cancel();
   render(&state);
}

int main() {
   writeln("Asteroids - Rico was here");
   init_state(&state);

   int frame_per_second = 60;
   int frame_milliseconds = 1000 / frame_per_second;
   sys_timer_request(frame_milliseconds);
   return 42; 
}