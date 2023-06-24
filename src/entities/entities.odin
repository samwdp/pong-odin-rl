package entities

import rl "vendor:raylib"
import "core:fmt"

GameState :: struct {
    show_fps:      bool,
    target_fps:    i32,
    player1_score: i32,
    player2_score: i32,
    font_size:     f32,
    font_padding:  f32,
    entities:      [dynamic]Entity,
}

Players :: enum {
    LEFT,
    RIGHT,
}
EntityType :: enum {
    BALL,
    PADDLE,
}

Entity :: struct {
    type:            EntityType,
    pos, dim, speed: rl.Vector2,
    update:          proc(self: ^Entity, game: ^GameState),
    draw:            proc(self: ^Entity),
}

update_font :: proc(game: ^GameState){

    if rl.IsKeyDown(rl.KeyboardKey.J) {
        game.font_size -= 1
    }

    if rl.IsKeyDown(rl.KeyboardKey.K) {

        game.font_size += 1
    }
}

updateBall :: proc(self: ^Entity, game: ^GameState) {
    self.pos.x += self.speed.x * rl.GetFrameTime()
    self.pos.y += self.speed.y * rl.GetFrameTime()
    if self.pos.y + self.dim.x >= f32(rl.GetScreenHeight()) ||
       self.pos.y - self.dim.x <= 0 {
        self.speed.y *= -1.0
    }

    if self.pos.x + self.dim.x >= f32(rl.GetScreenWidth()) ||
       self.pos.x - self.dim.x <= 0 {

        self.speed.x *= -1.0
    }
}

updatePlayer1 :: proc(self: ^Entity, game: ^GameState) {
    if rl.IsKeyDown(rl.KeyboardKey.W) {
        self.pos.y -= self.speed.y * rl.GetFrameTime()
    }

    if rl.IsKeyDown(rl.KeyboardKey.S) {
        self.pos.y += self.speed.y * rl.GetFrameTime()
    }
    paddle_collision(self)
    ball_collision(self, game)
}


updatePlayer2 :: proc(self: ^Entity, game: ^GameState) {
    if rl.IsKeyDown(rl.KeyboardKey.UP) {
        self.pos.y += self.speed.y * rl.GetFrameTime()
    }

    if rl.IsKeyDown(rl.KeyboardKey.DOWN) {
        self.pos.y -= self.speed.y * rl.GetFrameTime()
    }
    paddle_collision(self)
    ball_collision(self, game)
}

drawBall :: proc(self: ^Entity) {
    rl.DrawCircleV(self.pos, self.dim.x, rl.BLUE)
}

drawPaddle :: proc(self: ^Entity) {
    rl.DrawRectangleV(self.pos, self.dim, rl.BLUE)
}

paddle_collision :: proc(self: ^Entity) {
    if self.pos.y <= 0 {
        self.pos.y = 0
    }

    if self.pos.y + self.dim.y >= f32(rl.GetScreenHeight()) {
        self.pos.y = f32(rl.GetScreenHeight()) - self.dim.y
    }
}

ball_collision :: proc(self: ^Entity, game: ^GameState) {
    ball := find_entity(game, EntityType.BALL)
    rect := rl.Rectangle {
        x      = self.pos.x,
        y      = self.pos.y,
        width  = self.dim.x,
        height = self.dim.y,
    }
    if (rl.CheckCollisionCircleRec(ball.pos, ball.dim.x, rect)) {
        ball.speed.x *= -1
    }

}

find_entity :: proc(game: ^GameState, type: EntityType) -> ^Entity {
    for _, i in game.entities {
        if game.entities[i].type == type {
            return &game.entities[i]
        }
    }
    return nil
}

draw_left_text :: proc(font: rl.Font, game: ^GameState) {
    left := rl.TextFormat("Player 1: %d", game.player1_score)
    lefttextdim := rl.MeasureTextEx(
        font,
        left,
        game.font_size,
        game.font_padding,
    )
    left_text_location := rl.Vector2{
        ((f32(rl.GetScreenWidth()) * 0.25) - lefttextdim.y),
        10,
    }
    rl.DrawTextEx(
        font,
        left,
        left_text_location,
        game.font_size,
        game.font_padding,
        rl.RED,
    )
}

draw_right_text :: proc(font: rl.Font, game: ^GameState) {
    left := rl.TextFormat("Player 2: %d", game.player2_score)
    lefttextdim := rl.MeasureTextEx(
        font,
        left,
        game.font_size,
        game.font_padding,
    )
    left_text_location := rl.Vector2{
        ((f32(rl.GetScreenWidth()) * 0.75) - lefttextdim.y),
        10,
    }
    rl.DrawTextEx(
        font,
        left,
        left_text_location,
        game.font_size,
        game.font_padding,
        rl.RED,
    )
}
