#include "sys_host.h"
#include "micromath.h"
#include "render.h"

void vector_line(float x0, float y0, float x1, float y1) {
   sys_vector_gun(0);
   sys_vector_move_to(x0, y0);
   sys_vector_gun(1);
   sys_vector_move_to(x1, y1);
   sys_vector_gun(0);
}

void draw_circle(float x0, float y0, float radius, int segments, int offset) {
   int delta = 256 / segments;
   double x_start;
   double y_start;
   for (int i = 0; i < segments; i++) {
      unsigned char a = delta * i + offset;
      double x = radius * fixed_sin(a) + x0;
      double y = radius * fixed_cos(a) + y0;
      sys_vector_move_to(x, y);
      if (i == 0) {
         x_start = x;
         y_start = y;
         sys_vector_gun(1);
      }
   }
   sys_vector_move_to(x_start, y_start);
   sys_vector_gun(0);
}

void draw_test_pattern(int counter) {
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

   draw_circle(VECTOR_MAX_X / 2, VECTOR_MAX_Y / 2, VECTOR_MAX_X / 4, 12, counter);

   sys_vector_render();
}
