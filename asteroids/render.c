#include "asteroids.h"
#include "sys_host.h"
#include "micromath.h"
#include "render.h"

int asteroid_sizes[] = {120, 50, 20};

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

void render_asteroid(struct asteroid* a) {
    float start_x;
    float start_y;
    double* pModel = a->model;
    int size = asteroid_sizes[a->size];
    for (int i=0; i<ASTEROID_MODEL_POINT_COUNT; i++) {
        double model_x = *pModel++;
        double model_y = *pModel++;
        double x = a->pos.x + size * model_x;
        double y = a->pos.y + size * model_y;
        sys_vector_move_to(x, y);
        if (i == 0) {
            sys_vector_gun(1);
            start_x = x;
            start_y = y;
        }
    }
    sys_vector_move_to(start_x, start_y);
    sys_vector_gun(0);
}

void render(struct asteroids_state* state) {
    for (int i = 0; i < MAX_ASTEROIDS; i++) {
        struct asteroid *pa = &state->asteroids[i];
        if (!pa->active)
            continue;
        render_asteroid(pa);
    }
    sys_vector_render();
}