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

local TURNING_TIMES = {0.05, 0.12, 0.18, 0.24, 0.30, 0.36, 0.42, 0.48, 0.54, 0.60, 0.66 }
local RETURNING_TIMES = {0.06, 0.12, 0.17, 0.21, 0.33, 0.45, 0.57 }
local COUNTERTURNING_TIMES ={0.03, 0.06, 0.09, 0.12, 0.15, 0.18}

function Racer:new()
    local r = Entity:new()
    setmetatable(r, Racer)
    
    r.spritesheet = love.graphics.newImage("assets/img/mario.png")
    r.spritesheet:setFilter("nearest", "nearest")
    
    r.faces_sprites = {}
    r.face = M
    r.direction = STRAIGHT
    r.time_in_neutral_input = 0
    r.pressed_time = 0
    r.current_turn_state = 1
    r.current_counterturn_state = 1

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
    self.pressed_time = input_state.press_time

    if input_state.direction_changed then
        self.current_turn_state = 1
        self.current_counterturn_state = 1
    end

    if input_state.input_direction == LEFT and self.face > L5 then
        self.time_in_neutral_input = 0

        if input_state.press_time > TURNING_TIMES[self.current_turn_state] then
            self.face = self.face - 1
            self.current_turn_state = self.current_turn_state + 1
        end

        if self.face > M then
            if input_state.press_time > COUNTERTURNING_TIMES[self.current_counterturn_state] then
                self.face = self.face - 1
                self.current_counterturn_state = self.current_counterturn_state + 1
            end
        end

    elseif input_state.input_direction == RIGHT and self.face < R5 then
        self.time_in_neutral_input = 0

        if input_state.press_time > TURNING_TIMES[self.current_turn_state] then
            self.face = self.face + 1
            self.current_turn_state = self.current_turn_state + 1
        end

        if self.face < M then
            if input_state.press_time > COUNTERTURNING_TIMES[self.current_counterturn_state] then
                self.face = self.face + 1
                self.current_counterturn_state = self.current_counterturn_state + 1
            end
        end

    elseif input_state.input_direction == STRAIGHT then
        self.time_in_neutral_input = self.time_in_neutral_input + dt
    
        if self.face < M then -- facing left
            if self.time_in_neutral_input > RETURNING_TIMES[self.current_turn_state] then
                self.face = self.face + 1
                self.current_turn_state = self.current_turn_state + 1
            end
        elseif self.face > M then -- facing right
            if self.time_in_neutral_input > RETURNING_TIMES[self.current_turn_state] then
                self.face = self.face - 1
                self.current_turn_state = self.current_turn_state + 1
            end
        else
            self.time_in_neutral_input = 0
            self.current_turn_state = 1
            self.current_counterturn_state = 1
        end
    end

    self.direction = input_state.input_direction
end

function Racer:draw()
    love.graphics.draw(self.spritesheet, self.faces_sprites[self.face], 112, 150)
end

return Racer
