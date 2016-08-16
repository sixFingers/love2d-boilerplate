local Node = require("src.node.node")
local Camera = Class{__includes = Node}

local screenWidth, screenHeight = love.graphics.getDimensions()

function Camera:init()
    Node.init(self)

    self.target = Vec3{0, 0, 0}

    self.minZoom = 1
    self.maxZoom = 20
    self.currentZoom = self.maxZoom

    self.phi = 0
    self.theta = 0
end

function Camera:zoom(delta)
    self.currentZoom = Utils.clamp(self.currentZoom + delta, self.minZoom, self.maxZoom)
    self.matrixDirty = true
end

function Camera:rotate(x, y)
    local halfPi = math.pi / 2
    local dx = x / screenWidth
    local dy = y / screenHeight
    self.phi = Utils.clamp(self.phi + dy, -halfPi + .01, halfPi - .01)
    self.theta = Utils.clamp(self.theta + dx, 0, math.pi)
    self.matrixDirty = true
end

function Camera:pan(x, y)
    local dx = x / screenWidth
    local dy = y / screenHeight

    local delta = Vec3{self.target.x - self.position.x, 0, self.target.z - self.position.z}:normalize()
    local forward = (self.target - self.position):normalize()
    local side = delta:cross(Vec3.unit_y)

    delta = delta * dy * self.currentZoom
    side = side * dx * self.currentZoom

    self.target = self.target - side + delta
    self.matrixDirty = true
end

function Camera:refreshMatrix()
    self.position.x = self.target.x - self.currentZoom * math.cos(self.phi) * math.cos(self.theta)
    self.position.y = self.target.y - self.currentZoom * math.sin(self.phi)
    self.position.z = self.target.z - self.currentZoom * math.cos(self.phi) * math.sin(self.theta)
    self.matrix = Mat4():look_at(self.position, self.target, Vec3.unit_y)
end

return Camera
