local Vector2D = {}
Vector2D.__index = Vector2D

function Vector2D:new(x, y)
    local v = {}
    setmetatable(v, Vector2D)

    v.x = x or 0
    v.y = y or 0

    return v
end

function Vector2D:getModule()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector2D:add(v)
    self.x = self.x + v.x
    self.y = self.y + v.y
end

function Vector2D:scale(scalar)
    self.x = self.x * scalar
    self.y = self.y * scalar
end

function Vector2D:normalize()
    local module = self:getModule()
    if module > 0 then
        self.x = self.x / module
        self.y = self.y / module
    end
end

function Vector2D:clamp(maxLen)
    local len = self:getModule()
    if len > maxLen then
        self.x = self.x / len * maxLen
        self.y = self.y / len * maxLen
    end
end

return Vector2D
