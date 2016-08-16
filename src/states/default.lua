local state = {}

local shader, camera, scene, mouseState, mouseRay

function state:init()
    scene = Core.Scene()
    camera = Node.Camera()
    -- Core.Renderer.debugMode(true)
end

function state:mousepressed(x, y, mouse_btn)
    mouseState = mouse_btn == 1 and "orbit" or "pan"
end

function state:mousemoved(x, y, dx, dy)
    if (mouseState == "orbit") then
        camera:rotate(dx, -dy)
    elseif (mouseState == "pan") then
        camera:pan(dx, dy)
    end
end

function state:wheelmoved(x, y)
    camera:zoom(y)
end

function state:mousereleased(x, y, mouse_btn)
    mouseState = nil
end

function state:keypressed(code, scan, isRepeat)
end

function state:textinput(t)
end

function state:keyreleased(code, scan, isRepeat)
end

function state:update(dt)
end

function state:draw()
    Core.Renderer.draw(scene, camera)
end

return state
