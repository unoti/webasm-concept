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

int rand_int(int min, int max) {
   int dist = max - min + 1;
   return sys_random() * dist + min;
}

int rand_index(int limit) {
   return rand_int(0, limit - 1);
}

double rand_range(double low, double hi) {
   double range = hi - low;
   return sys_random() * range + low;
}

void populate_asteroids(struct asteroids_state* state) {
   int model = 0;
   for (int i=0; i<MAX_ASTEROIDS; i++) {
      int id = ++state->last_id_assigned;
      struct asteroid* a = &state->asteroids[i];
      a->id = id;
      a->active = TRUE;
      a->size = rand_index(ASTEROID_SIZE_COUNT);
      a->model = get_asteroid_model(model);
      a->pos.x = sys_random() * VECTOR_MAX_X;
      a->pos.y = sys_random() * VECTOR_MAX_Y;
      a->vel.x = rand_range(-ASTEROID_VELOCITY_MAX, ASTEROID_VELOCITY_MAX);
      a->vel.y = rand_range(-ASTEROID_VELOCITY_MAX, ASTEROID_VELOCITY_MAX);
      model = (model + 1) % ASTEROID_MODEL_COUNT;
   }
}

void update(struct asteroids_state* state, double elapsed_seconds) {
   state->frame_count++;
   if (state->frame_count > 500) {
      state->frame_count = 0;
      populate_asteroids(state);
   }

   for (int i=0; i<MAX_ASTEROIDS; i++) {
      struct asteroid* a = &state->asteroids[i];
      if (!a->active)
         continue;
      
      a->pos.x += a->vel.x * elapsed_seconds;
      a->pos.y += a->vel.y * elapsed_seconds;
   }
}

void init_state(struct asteroids_state* state) {
   state->last_id_assigned = 0;
   state->frame_count = 0;
   populate_asteroids(state);
}

/** Called by host when a timer expires. */
void sys_timer_expired(float elapsed_milliseconds) {
   //writeln("asteroids.c: Timer called");
   //writeln("Cancelling timer");
   //sys_timer_cancel();
   float elapsed_seconds = elapsed_milliseconds / 1000;
   update(&state, elapsed_seconds);
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