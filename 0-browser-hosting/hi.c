
extern void uart_write(int n);

void write_string(char* s) {
   while (*s) {
      uart_write(*s++);
   }
}

void writeln(char* s) {
   write_string(s);
   uart_write('\n');
}

int main() {
   writeln("Rico was here");
   return 42; 
}