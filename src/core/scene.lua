local Scene = Class{}

local texture = love.graphics.newImage("assets/textures/crate.png", {mipmaps = true})
texture:setFilter("linear", "linear", 16)

function Scene:init()
    self.models = {}
    self.modelCount = 0
end

function Scene:addModels(...)
    local nargs = select('#', ...)

    for m = 1, nargs do
        local model = select(m, ...)
        self.models[model] = true
    end

    self.modelCount = self.modelCount + nargs
end

function Scene:removeModels(...)
    local nargs = select('#', ...)
    for m = 1, nargs do
        local model = select(m, ...)
        table.remove(self.models, model)
    end

    self.modelCount = math.min(self.modelCount - nargs, 0)
end

return Scene
