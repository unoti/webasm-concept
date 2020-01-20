extern void sys_putc_int(int n);
extern void sys_timer_request(int period_ms);
extern void sys_timer_cancel();

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

int sys_init() {
   writeln("Rico was here");
   timer_count = 0;
   sys_timer_request(1000);
   return 42; 
}