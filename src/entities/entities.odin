package entities

import rl "vendor:raylib"

GameState :: struct {
    show_fps:   bool,
    target_fps: i32,
    entities:   [dynamic]Entity,
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
    ball_collision(self, game)
    paddle_collision(self)

}


updatePlayer2 :: proc(self: ^Entity, game: ^GameState) {
    if rl.IsKeyDown(rl.KeyboardKey.UP) {
        self.pos.y += self.speed.y * rl.GetFrameTime()
    }

    if rl.IsKeyDown(rl.KeyboardKey.DOWN) {
        self.pos.y -= self.speed.y * rl.GetFrameTime()
    }

    ball_collision(self, game)
    paddle_collision(self)
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
