local Model = Class{__includes = Node}

local modelFolder = "assets/models"
local shaderFolder = "assets/shaders"

Model.modelCache = {}
Model.shaderCache = {}

function Model:init(model, shader)
    Node.init(self)

    local path = modelFolder .. model
    Model.modelCache[model] = Model.modelCache[model] or IQM.load(path)

    path = shaderFolder .. shader
    Model.shaderCache[shader] = Model.shaderCache[shader] or love.graphics.newShader(path)

    self.mesh = Model.modelCache[model].mesh
    local bounds = Model.modelCache[model].bounds.base
    local min = Vec3{bounds.min[1], bounds.min[2], bounds.min[3]}
    local max = Vec3{bounds.max[1], bounds.max[2], bounds.max[3]}
    local center = max - min / 2
    self.bounds = {
        min = min, max = max, center = center
    }
    self.shader = Model.shaderCache[shader]
end

return Model
