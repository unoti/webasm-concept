#define VECTOR_MAX_X 1200
#define VECTOR_MAX_Y 1200
#define TEST_BAR_COUNT 16

void vector_line(float x0, float y0, float x1, float y1);
void draw_circle(float x0, float y0, float radius, int segments, int offset);
void draw_test_pattern(int counter);
void render(struct asteroids_state* state);
