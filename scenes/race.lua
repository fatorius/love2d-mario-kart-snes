local Racer = require("entities.racer")

scene = {}
entities = {}

input_state = {}

-- Constantes de direções
local LEFT = -1
local STRAIGHT = 0
local RIGHT = 1

function scene.load()
    love.graphics.setBackgroundColor(0.9686, 0.8784, 0.5137)

    local r = Racer:new()
    table.insert(entities, r)

    input_state.direction = STRAIGHT
    input_state.press_time = 0
end

function scene.update(dt)
    if love.keyboard.isDown("right") then
        input_state.direction = RIGHT
        input_state.press_time = input_state.press_time + dt
    elseif love.keyboard.isDown("left") then
        input_state.direction = LEFT
        input_state.press_time = input_state.press_time + dt
    else
        input_state.direction = STRAIGHT
        input_state.press_time = 0
    end

    for _, e in ipairs(entities) do
        e:update(dt, input_state)
    end
end

function scene.draw()
    for _, e in ipairs(entities) do
        e:draw()
    end
end

return scene
