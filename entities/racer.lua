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

function Racer:new()
    local r = Entity:new()
    setmetatable(r, Racer)
    
    r.spritesheet = love.graphics.newImage("assets/img/mario.png")
    
    r.faces_sprites = {}
    r.face = M

    r:loadSpriteSheet()

    return r
end

function Racer:loadSpriteSheet()
    local sprite_w = 32
    local sprite_h = 32

    local current_x = 17
    local current_y = 34

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

function Racer:update(dt)
end

function Racer:draw()
    love.graphics.draw(self.spritesheet, self.faces_sprites[self.face], 112, 150)
end

return Racer
