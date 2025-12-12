local Entity = {}
Entity.__index = Entity

function Entity:new()
    local e = { }
    setmetatable(e, self)
    return e
end

function Entity:update(dt) 
end

function Entity:draw() 
end

return Entity