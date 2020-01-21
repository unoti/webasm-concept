// Import functions provided by host and imported into the module.
extern void sys_putc_int(int n);
extern void sys_timer_request(int period_ms);
extern void sys_timer_cancel();
extern void sys_vector_gun(int on);
extern void sys_vector_move_to(float x, float y);
extern void sys_vector_render(void);
extern void sys_print_num(double x);
extern double sys_random(void);

void writeln(char* s);