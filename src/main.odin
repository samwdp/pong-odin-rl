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
    defer rl.CloseWindow()

    rl.SetWindowState(rl.ConfigFlags{.WINDOW_RESIZABLE})

    paddle_width: f32 = 0.2 * WINDOW_SCALE
    paddle_height: f32 = paddle_width * 8

    ball := ent.Entity {
        update = ent.updateBall,
        draw = ent.drawBall,
        speed = {150, 150},
        dim = {WINDOW_SCALE * 0.1, 0},
        pos = {
            f32(rl.GetScreenWidth()) / 2.0,
            f32(rl.GetScreenHeight()) / 2.0,
        },
    }

    player1 := ent.Entity {
        update = ent.updatePlayer1,
        draw = ent.drawPaddle,
        pos = {
            WINDOW_PADDING,
            f32(rl.GetScreenHeight()) / 2.0 - f32(paddle_height) / 2.0,
        },
        speed = {150, 150},
        dim = {paddle_width, paddle_height},
    }

    player2 := ent.Entity {
        update = ent.updatePlayer2,
        draw = ent.drawPaddle,
        pos = {
            f32(rl.GetScreenWidth()) - paddle_width - WINDOW_PADDING,
            f32(rl.GetScreenHeight()) / 2.0 - f32(paddle_height) / 2.0,
        },
        speed = {150, 150},
        dim = {paddle_width, paddle_height},
    }

    game := ent.GameState {
        show_fps = false,
        entities = {ball, player1, player2},
        target_fps = rl.GetMonitorRefreshRate(0),
        font_size = 35.0,
        font_padding = 1.0,
    }

    rl.SetTargetFPS(game.target_fps)


    font := rl.LoadFont("./data/fonts/MadeleinaSans-2VY3.ttf")
    defer rl.UnloadFont(font)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        defer rl.EndDrawing()

        rl.ClearBackground(rl.RAYWHITE)

        if game.show_fps {
            rl.DrawFPS(10, 10)
        }

        ent.update_font(&game)
        ent.draw_right_text(font, &game)
        ent.draw_left_text(font, &game)

        for _, i in game.entities {
            entity := &game.entities[i]
            entity.update(entity, &game)
            entity.draw(entity)
        }
    }
}
