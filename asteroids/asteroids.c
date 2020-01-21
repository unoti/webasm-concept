#include "sys_host.h"
#include "render.h"

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

void print_num(float n) {
   n *= 10;
   for (int i=0; i < n; i++) {
      sys_putc_int('*');
   }
   sys_putc_int('\n');
}

/** Called by host when a timer expires. */
void sys_timer_expired(float elapsed_milliseconds) {
   writeln("asteroids.c: Timer called");
   draw_test_pattern(timer_count);
   if (++timer_count >= 100) {
      writeln("Disabling timer");
      sys_timer_cancel();
   }
}

int main() {
   writeln("Rico was here");
   draw_test_pattern(0);
   timer_count = 0;
   sys_timer_request(100);
   return 42; 
}