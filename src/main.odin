package main

import "core:fmt"
import rl "vendor:raylib"
import ent "entities"

WINDOW_SCALE :: 80
WINDOW_WIDTH :: 16
WINDOW_HEIGHT :: 9
WINDOW_PADDING :: 20

main :: proc() {
    rl.InitWindow(
        WINDOW_WIDTH * WINDOW_SCALE,
        WINDOW_HEIGHT * WINDOW_SCALE,
        "Pong",
    )
    paddle_width: f32 = 0.5 * WINDOW_SCALE
    paddle_height: f32 = paddle_width * 4

    ball := ent.Entity {
        update = ent.updateBall,
        draw = ent.drawBall,
        speed = {150, 150},
        dim = {WINDOW_SCALE / 4, 0},
        pos = {
            f32(rl.GetScreenWidth()) / 2.0,
            f32(rl.GetScreenHeight()) / 2.0,
        },
    }
    player1 := ent.Entity {
        update = ent.updatePlayer1,
        draw = ent.drawPaddle,
        pos = {WINDOW_PADDING, f32(rl.GetScreenHeight()) / 2.0},
        speed = {150, 150},
        dim = {paddle_width, paddle_height},
    }
    player2 := ent.Entity {
        update = ent.updatePlayer2,
        draw = ent.drawPaddle,
        pos = {
            f32(rl.GetScreenWidth()) - paddle_width - WINDOW_PADDING,
            f32(rl.GetScreenHeight()) / 2.0,
        },
        speed = {150, 150},
        dim = {paddle_width, paddle_height},
    }
    a := ent.GameState {
        show_fps = true,
        entities = {ball, player1, player2},
        target_fps = rl.GetMonitorRefreshRate(0),
    }
    rl.SetTargetFPS(a.target_fps)

    defer rl.CloseWindow()

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        defer rl.EndDrawing()
        rl.ClearBackground(rl.RAYWHITE)
        if a.show_fps {
            rl.DrawFPS(10, 10)
        }
        for _, i in a.entities {
            entity := &a.entities[i]
            entity.update(entity, &a)
            entity.draw(entity)
        }
    }
}
