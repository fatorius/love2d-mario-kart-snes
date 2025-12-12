local currentScene = nil

local VIRTUAL_W = 256
local VIRTUAL_H = 224

local SCALE_X = 1
local SCALE_Y = 1

function loadScene(name)
    currentScene = require("scenes." .. name)
    currentScene.load()
end

function love.load()
    love.window.setMode(400, 300, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    SCALE_X = love.graphics.getWidth()  / VIRTUAL_W
    SCALE_Y = love.graphics.getHeight() / VIRTUAL_H

    love.window.setTitle("Mario Kart SNES")

    loadScene("begin")
end

function love.update(dt)
    currentScene.update(dt)
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(SCALE_X, SCALE_Y)

    currentScene.draw()

    love.graphics.pop()
end
