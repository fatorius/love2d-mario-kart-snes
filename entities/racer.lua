local Entity = require("entities.entity")
local Vector2D = require("math.vector2d")

local Racer = setmetatable({}, { __index = Entity })
Racer.__index = Racer

-- Constantes de faces
local L5 = 1
local L4 = 2
local L3 = 3
local L2 = 4
local L1 = 5
local MIDDLE = 6
local R1 = 7
local R2 = 8
local R3 = 9
local R4 = 10
local R5 = 11

-- Constantes de direções
local LEFT = -1
local STRAIGHT = 0
local RIGHT = 1

function Racer:new()
    local r = Entity:new()
    setmetatable(r, Racer)
    
    r.mario_spritesheet = love.graphics.newImage("assets/img/mario.png")
    r.smoke_spritesheet = love.graphics.newImage("assets/img/smoke_particles.png")
    
    r.faces_sprites = {}
    r.smoke_sprites = {}

    -- consts
    r.ACCELERATION = 50
    r.DECELERATION = 60
    r.MAX_SPEED = 200
    r.MIN_SPEED = 0

    -- states
    r.face = MIDDLE

    -- sprite positioning consts
    r.SCREEN_X = 112
    r.SCREEN_Y = 150

    -- movimenting
    r.x, r.y = 590, 400 -- posição no mundo
    r.vDirection = Vector2D:new(0, 1) -- vetor de direção NORMALIZADO
    r.vSpeed = Vector2D:new(0, 0) -- vetor de velocidade

    r:loadMarioSpriteSheet()
    r:loadSmokeSpriteSheet()

    return r
end

function Racer:loadSmokeSpriteSheet()
    local sprite_w = 16
    local sprite_h = 16

    self.smoke_sprites.big_smoke = love.graphics.newQuad(
        0,
        0,
        sprite_w,
        sprite_h,
        self.smoke_spritesheet:getWidth(),
        self.smoke_spritesheet:getHeight()
    ) 

    self.smoke_sprites.small_smoke = love.graphics.newQuad(
        16,
        0,
        sprite_w,
        sprite_h,
        self.smoke_spritesheet:getWidth(),
        self.smoke_spritesheet:getHeight()
    ) 
end

function Racer:loadMarioSpriteSheet()
    local sprite_w = 31
    local sprite_h = 31

    local current_x = 5
    local current_y = 35

    for i = 1, 11 do
        self.faces_sprites[i] = love.graphics.newQuad(
            current_x,
            current_y,
            sprite_w,
            sprite_h,
            self.mario_spritesheet:getWidth(),
            self.mario_spritesheet:getHeight()
        ) 

        current_x = current_x + sprite_w
    end
end

function Racer:accelerate(dt)
    self.vSpeed.x = self.vSpeed.x + self.vDirection.x * self.ACCELERATION * dt
    self.vSpeed.y = self.vSpeed.y + self.vDirection.y * self.ACCELERATION * dt

    self.vSpeed:clamp(self.MAX_SPEED)
end

function Racer:decelerate(dt, current_speed)
    local decel = self.DECELERATION * dt 
    local finalSpeed = math.max(self.MIN_SPEED, current_speed - decel)

    self.vSpeed:normalize()
    self.vSpeed:scale(finalSpeed)
end

function Racer:update_direction(dt, input_state)
    
end

function Racer:update_speed(dt, input_state)
    local speedModule = self.vSpeed:getModule()

    if input_state.accelerating then
        if speedModule < self.MAX_SPEED then
            self:accelerate(dt)
        end
    elseif self.vSpeed:getModule() > self.MIN_SPEED then 
        self:decelerate(dt, speedModule)
    end
end


function Racer:update_position(dt)
    self.x = self.x + self.vSpeed.x * dt
    self.y = self.y + self.vSpeed.y * dt
end

function Racer:update_sprite(dt, input_state)
    self.face = MIDDLE

    if input_state.input_direction ~= STRAIGHT and self.face == MIDDLE then
        if input_state.input_direction == LEFT then
            self.face = L1
        else
            self.face = R1
        end
    end

    -- Aqui a face do racer deve ser atualizada de acordo com o dot product dos vetores de velocidade e direção
    -- dot = 1, face = MIDDLE
end

function Racer:update(dt, input_state)
    self:update_direction(dt, input_state)
    self:update_speed(dt, input_state)
    self:update_position(dt, input_state)
    

    self:update_sprite(dt, input_state)

    -- com base no vetor de direção, o paralax do fundo deve ser realizado (vetor -> pan pelo sprite do fundo) 
end

function Racer:draw()
    love.graphics.draw(self.mario_spritesheet, self.faces_sprites[self.face], self.SCREEN_X, self.SCREEN_Y)

    love.graphics.print(self.vSpeed.x, 0, 0)
    love.graphics.print(self.vSpeed.y, 0, 20)
end

return Racer
