local Racer = require("entities.racer")
local WorldMap = require("entities.worldmap")

scene = {}
entities = {}

local racer
local input_state = {}

-- Constantes de direções
local LEFT = -1
local STRAIGHT = 0
local RIGHT = 1

function scene.load()
    love.graphics.setBackgroundColor(0.9686, 0.8784, 0.5137)

    racer = Racer:new()
    world_map = WorldMap:new()

    -- table.insert(entities, e)

    input_state.input_direction = STRAIGHT
    input_state.previous_direction = STRAIGHT
    input_state.direction_changed = false
    input_state.press_time = 0
end

function scene.update(dt)
    -- Direction of movement
    local inputing_left = love.keyboard.isDown('left') and 1 or 0
    local inputing_right = love.keyboard.isDown('right') and 1 or 0

    input_state.input_direction = inputing_right - inputing_left

    if input_state.input_direction ~= input_state.previous_direction then
        input_state.direction_changed = true
        input_state.press_time = 0
    end

    if input_state.input_direction ~= 0 then
        input_state.press_time = input_state.press_time + dt
    else
        input_state.press_time = 0
    end
    
    -- Acceleration
    input_state.accelerating = love.keyboard.isDown("z")

    racer:update(dt, input_state)
    world_map:update(dt, racer)

    for _, e in ipairs(entities) do
        e:update(dt)
    end

    -- Side-effects
    input_state.previous_direction = input_state.input_direction
    input_state.direction_changed = false
end

function scene.draw()
    world_map:draw()
    racer:draw()

    for _, e in ipairs(entities) do
        e:draw()
    end
end

return scene
