local Entity = require("entities.entity")

local Racer = setmetatable({}, { __index = Entity })
Racer.__index = Racer

-- Constantes de faces
local L5 = 1
local L4 = 2
local L3 = 3
local L2 = 4
local L1 = 5
local M = 6
local R1 = 7
local R2 = 8
local R3 = 9
local R4 = 10
local R5 = 11

-- Constantes de direções
local LEFT = -1
local STRAIGHT = 0
local RIGHT = 1

local TURNING_TIME = {0.06, 0.21, 0.33, 0.45, 0.57 }

function Racer:new()
    local r = Entity:new()
    setmetatable(r, Racer)
    
    r.spritesheet = love.graphics.newImage("assets/img/mario.png")
    
    r.faces_sprites = {}
    r.face = M
    r.direction = STRAIGHT

    r:loadSpriteSheet()

    return r
end

function Racer:loadSpriteSheet()
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
            self.spritesheet:getWidth(),
            self.spritesheet:getHeight()
        ) 

        current_x = current_x + sprite_w
    end
end

function Racer:update(dt, input_state)
    if input_state.direction == LEFT then
        if input_state.press_time < TURNING_TIME[1] then
            self.face = L1
        elseif input_state.press_time < TURNING_TIME[2] then
            self.face = L2
        elseif input_state.press_time < TURNING_TIME[3] then
            self.face = L3
        elseif input_state.press_time < TURNING_TIME[4] then
            self.face = L4
        else
            self.face = L5
        end
    elseif input_state.direction == RIGHT then
        if input_state.press_time < TURNING_TIME[1] then
            self.face = R1
        elseif input_state.press_time < TURNING_TIME[2] then
            self.face = R2
        elseif input_state.press_time < TURNING_TIME[3] then
            self.face = R3
        elseif input_state.press_time < TURNING_TIME[4] then
            self.face = R4
        else
            self.face = R5
        end
    else
        self.face = M
    end

    self.direction = input_state.direction
end

function Racer:draw()
    love.graphics.draw(self.spritesheet, self.faces_sprites[self.face], 112, 150)
end

return Racer
