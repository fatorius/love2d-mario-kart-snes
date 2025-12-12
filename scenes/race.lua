local Racer = require("entities.racer")

scene = {}
entities = {}

function scene.load()
    love.graphics.setBackgroundColor(0.9686, 0.8784, 0.5137)

    local r = Racer:new()
    table.insert(entities, r)
end

function scene.update(dt)
    for _, e in ipairs(entities) do
        e:update(dt)
    end
end

function scene.draw()
    for _, e in ipairs(entities) do
        e:draw()
    end
end

return scene
