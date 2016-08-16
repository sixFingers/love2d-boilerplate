local Node = Class{}

function Node:init()
    self.position = Vec3{0, 0, 0}
    self.rotation = Vec3{0, 0, 0}
    self.orientation = Quat.new(0, 0, 0, 1)
    self.scale = Vec3{1, 1, 1}

    self.matrix = Mat4()
    self.matrixDirty = true
end

function Node:setRotation(x, y, z)
    self.rotation = Vec3{x, y, z}
    self.orientation = Quat.new(0, 0, 0, 1)
    self.orientation = self.orientation * Quat.rotate(self.rotation.x, Vec3.unit_x)
    self.orientation = self.orientation * Quat.rotate(self.rotation.y, Vec3.unit_y)
    self.orientation = self.orientation * Quat.rotate(self.rotation.z, Vec3.unit_z)
    self.matrixDirty = true
end

function Node:setPosition(x, y, z)
    self.position.x = x
    self.position.y = y
    self.position.z = z
    self.matrixDirty = true
end

function Node:refreshMatrix()
    self.matrix = Mat4():translate(self.position):rotate(self.orientation):scale(self.scale)
end

function Node:getTransform()
    if (self.matrixDirty) then
        self:refreshMatrix()
        self.matrixDirty = false
    end

    return self.matrix
end

return Node
