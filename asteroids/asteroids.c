#include <math.h>
#include "sys_host.h"

#define VECTOR_MAX_X 1200
#define VECTOR_MAX_Y 1200
#define TEST_BAR_COUNT 16

int timer_count;

void write_string(char* s) {
   while (*s) {
      sys_putc_int(*s++);
   }
}

void writeln(char* s) {
   write_string(s);
   sys_putc_int('\n');
}

/** Called by host when a timer expires. */
void sys_timer_expired(float elapsed_milliseconds) {
   writeln("asteroids.c: Timer called");
   if (++timer_count >= 10) {
      writeln("Disabling timer");
      sys_timer_cancel();
   }
}

void print_num(float n) {
   n *= 10;
   for (int i=0; i < n; i++) {
      sys_putc_int('*');
   }
   sys_putc_int('\n');
}

void vector_line(float x0, float y0, float x1, float y1) {
   sys_vector_gun(0);
   sys_vector_move_to(x0, y0);
   sys_vector_gun(1);
   sys_vector_move_to(x1, y1);
   sys_vector_gun(0);
}

void draw_test_pattern() {
   float dx = VECTOR_MAX_X / TEST_BAR_COUNT;
   // Vertical bars
   sys_vector_gun(0);
   sys_vector_move_to(0,0);
   sys_vector_gun(1);
   for (float x=0; x <= VECTOR_MAX_X - dx; x += dx) {
      sys_vector_move_to(x, 0);
      sys_vector_move_to(x, VECTOR_MAX_Y);
      sys_vector_move_to(x + dx, VECTOR_MAX_Y);
   }
   sys_vector_gun(0);

   // Horizontal bars
   float dy = VECTOR_MAX_Y / TEST_BAR_COUNT;
   sys_vector_gun(0);
   sys_vector_move_to(0, dy);
   for (float y=0; y <= VECTOR_MAX_Y - dy; y += dy) {
      vector_line(0, y, VECTOR_MAX_X, y);      
   }
   sys_vector_gun(0);
   sys_vector_render();
}

int main() {
   writeln("Rico was here");
   draw_test_pattern();
   timer_count = 0;
   sys_timer_request(1000);
   return 42; 
}