scene = {}
entities = {}

function scene.load()
end

function scene.update(dt)
    for _, e in ipairs(entities) do
        e:update(dt)
    end

    if love.keyboard.isDown("return") then
        loadScene("race")
    end
end

function scene.draw()
    love.graphics.setColor(1, 1, 1)

    for _, e in ipairs(entities) do
        e:draw()
    end
    
    love.graphics.print("Aperte ENTER \n para iniciar", 100, 100)
end

return scene
