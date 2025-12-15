local Entity = require("entities.entity")

local WorldMap = setmetatable({}, { __index = Entity })
WorldMap.__index = WorldMap

function WorldMap:new()
    local w = Entity:new()

    setmetatable(w, WorldMap)
    
    w.sprite = love.graphics.newImage("assets/img/test_mesh.png")
    w.sprite:setWrap("repeat", "repeat")


    -- POSITIONING CONSTS
    w.mapScreenX, w.mapScreenY = 0, 0

    w.scrollX, w.scrollY = 0, 0

    -- MESH CONSTS
    local SCALING_TERM = 0
    
    w.screenHeight = VIRTUAL_H * 0.2

    w.topLeftX = 0
    w.topRightX = VIRTUAL_W
    w.bottomRightX = VIRTUAL_W + SCALING_TERM
    w.bottomLeftX = 0 - SCALING_TERM

    w.mesh = w:createMesh()


    -- SHADER CONFIGs
    w.shader = love.graphics.newShader("shaders/perspective.glsl")

    w.shader:send("horizonY", w.screenHeight)
    w.shader:send("screenH", VIRTUAL_H)
    w.shader:send("screenW", VIRTUAL_W)

    return w
end

function WorldMap:createMesh()
    local format = {
        { "VertexPosition", "float", 2 },
        { "VertexTexCoord", "float", 2 },
    }

    local vertices = {
        { self.topLeftX, self.screenHeight, 0, 0 }, -- TL
        { self.topRightX, self.screenHeight, 1, 0 }, -- TR
        { self.bottomRightX, VIRTUAL_H, 1, 1 }, -- BR
        { self.bottomLeftX, VIRTUAL_H, 0, 1 }, -- BL
    }

    local mesh = love.graphics.newMesh(format, vertices, "fan")
    mesh:setTexture(self.sprite)

    return mesh
end

function WorldMap:drawWireframe()
    love.graphics.setColor(1, 0, 0)

    local count = self.mesh:getVertexCount()
    if count < 3 then return end

    for i = 1, count - 2 do
        local x1, y1 = self.mesh:getVertex(i)
        local x2, y2 = self.mesh:getVertex(i + 1)
        local x3, y3 = self.mesh:getVertex(i + 2)

        love.graphics.polygon(
            "line",
            x1, y1,
            x2, y2,
            x3, y3
        )
    end

    love.graphics.setColor(1, 1, 1)
end

function WorldMap:update(dt, racer)
    self.scrollX = self.scrollX - racer.vSpeed.x * dt
    self.scrollY = self.scrollY - racer.vSpeed.y * dt
end

function WorldMap:draw()
    love.graphics.setShader(self.shader)
    
    self.shader:send("scroll", {
        self.scrollX / self.sprite:getWidth(),
        self.scrollY / self.sprite:getHeight()
    })

    love.graphics.draw(self.mesh, self.mapScreenX, self.mapScreenY)
    love.graphics.setShader()

    self:drawWireframe()
end

return WorldMap
