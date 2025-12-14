local Entity = require("entities.entity")

local WorldMap = setmetatable({}, { __index = Entity })
WorldMap.__index = WorldMap

function WorldMap:new()
    local w = Entity:new()

    setmetatable(w, WorldMap)
    
    w.sprite = love.graphics.newImage("assets/img/test_mesh.png")

    -- POSITIONING CONSTS
    w.mapX = 0
    w.mapY = 0

    -- MESH CONSTS
    local SCALING_TERM = 100
    
    w.screenHeight = VIRTUAL_H * 0.2

    w.bottomRightX = VIRTUAL_W + SCALING_TERM
    w.bottomLeftX = 0 - SCALING_TERM

    w.mesh = w:createMesh()

    return w
end

function WorldMap:createMesh()
    local format = {
        { "VertexPosition", "float", 2 },
        { "VertexTexCoord", "float", 2 },
    }

    local vertices = {
        -- triângulo 1
        { 0, self.screenHeight, 0, 0 },          -- top-left
        { VIRTUAL_W, self.screenHeight, 1, 0 },  -- top-right
        { self.bottomLeftX, VIRTUAL_H, 0, 1 },   -- bottom-left

        -- triângulo 2
        { self.bottomLeftX, VIRTUAL_H, 0, 1 },   -- bottom-left
        { VIRTUAL_W, self.screenHeight, 1, 0 },  -- top-right
        { self.bottomRightX, VIRTUAL_H, 1, 1 }   -- bottom-right
    }

    local mesh = love.graphics.newMesh(format, vertices, "triangles")
    mesh:setTexture(self.sprite)

    return mesh
end

function WorldMap:updateUVs()
    -- triângulo 1
    self.mesh:setVertex(1, 0, self.screenHeight, 0, 0)
    self.mesh:setVertex(2, VIRTUAL_W, self.screenHeight, 1, 0)
    self.mesh:setVertex(3, self.bottomLeftX, VIRTUAL_H, 0, 1)

    -- triângulo 2
    self.mesh:setVertex(4, self.bottomLeftX, VIRTUAL_H, 0, 1)
    self.mesh:setVertex(5, VIRTUAL_W, self.screenHeight, 1, 0)
    self.mesh:setVertex(6, self.bottomRightX, VIRTUAL_H, 1, 1)
end

function WorldMap:drawWireframe()
    love.graphics.setColor(1,0,0)
    for i=1,self.mesh:getVertexCount(),3 do
        local a,b,c = {self.mesh:getVertex(i)}, {self.mesh:getVertex(i+1)}, {self.mesh:getVertex(i+2)}
        love.graphics.polygon("line", a[1],a[2], b[1],b[2], c[1],c[2])
    end
    love.graphics.setColor(1,1,1)
end


function WorldMap:update(dt, racer)
    self:updateUVs()
end

function WorldMap:draw()
    love.graphics.draw(self.mesh, self.mapX, self.mapY)
    self:drawWireframe()
end

return WorldMap
