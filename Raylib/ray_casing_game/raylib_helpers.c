// C file for raycasting logic helpers used by Assembly
#include "raylib.h"
#include <math.h>

#define MAP_SIZE 8
#define TILE_SIZE 60
#define FOV (M_PI / 3)
#define HALF_FOV (FOV / 2)
#define CASTED_RAYS 160
#define STEP_ANGLE (FOV / CASTED_RAYS)
#define MAX_DEPTH (MAP_SIZE * TILE_SIZE)

float playerX = 240;
float playerY = 240;
float playerAngle = M_PI;

const char *map =
    "########"
    "# #    #"
    "# #  ###"
    "#      #"
    "##     #"
    "#  ### #"
    "#   #  #"
    "########";

void DrawMap() {
    for (int i = 0; i < MAP_SIZE; i++) {
        for (int j = 0; j < MAP_SIZE; j++) {
            int idx = i * MAP_SIZE + j;
            Color c = map[idx] == '#' ? GRAY : DARKGRAY;
            DrawRectangle(j * TILE_SIZE, i * TILE_SIZE, TILE_SIZE - 1, TILE_SIZE - 1, c);
        }
    }
    DrawCircle((int)playerX, (int)playerY, 8, PURPLE);
}

void CastRays() {
    float angle = playerAngle - HALF_FOV;
    for (int ray = 0; ray < CASTED_RAYS; ray++, angle += STEP_ANGLE) {
        for (int depth = 1; depth < MAX_DEPTH; depth++) {
            float targetX = playerX - sinf(angle) * depth;
            float targetY = playerY + cosf(angle) * depth;
            int col = (int)(targetX / TILE_SIZE);
            int row = (int)(targetY / TILE_SIZE);
            int idx = row * MAP_SIZE + col;
            if (map[idx] == '#') {
                float fixedDepth = depth * cosf(playerAngle - angle);
                float wallHeight = 21000 / (fixedDepth + 0.0001f);
                if (wallHeight > 480) wallHeight = 480;
                float scale = 480.0f / CASTED_RAYS;
                float color = 255.0f / (1 + depth * depth * 0.0001f);
                DrawRectangle(480 + ray * scale, 240 - wallHeight / 2, scale, wallHeight, (Color){color, color, color, 255});
                break;
            }
        }
    }
}

void UpdatePlayer() {
    if (IsKeyDown(KEY_LEFT))  playerAngle -= 0.05f;
    if (IsKeyDown(KEY_RIGHT)) playerAngle += 0.05f;
    float dx = sinf(playerAngle) * 2.5f;
    float dy = -cosf(playerAngle) * 2.5f;
    if (IsKeyDown(KEY_UP)) {
        playerX += dx;
        playerY += dy;
    }
    if (IsKeyDown(KEY_DOWN)) {
        playerX -= dx;
        playerY -= dy;
    }
}