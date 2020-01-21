#define TRUE -1
#define FALSE 0
#define ASTEROID_SIZE_COUNT 3
#define ASTEROID_MODEL_POINT_COUNT 10
#define ASTEROID_MODEL_COUNT 12

// Tuning
#define MAX_ASTEROIDS 10
#define ASTEROID_VELOCITY_MAX 100

struct point {
    double x;
    double y;
};

struct asteroid {
    int id;
    unsigned char active; // True if this asteroid is alive.
    unsigned char size; // Index into asteroid_sizes[].
    double* model; // Pointer to the points in asteroid_models.
    struct point pos; // Position
    struct point vel; // Velocity
};

struct asteroids_state {
    int last_id_assigned;
    long frame_count;
    struct asteroid asteroids[MAX_ASTEROIDS];
};

double* get_asteroid_model(int model_num); // in asteroid_models.c.