local Renderer = {}

local screenWidth, screenHeight = love.graphics.getDimensions()
local projection_matrix = Mat4.from_perspective(45, screenWidth / screenHeight, 0, 1000)
local debugMode = false

function Renderer.debugMode(mode)
    debugMode = mode
end

function Renderer.draw(scene, camera)
    if debugMode then
        gl.PolygonMode(GL.FRONT_AND_BACK, GL.LINE)
    else
        gl.PolygonMode(GL.FRONT_AND_BACK, GL.FILL)
    end

    Lovegl.setDepthTest("less")

    local currentShader = nil

    local function switchShader(shader)
        Lovegl.setShader(shader)
        -- L3D.update_shader(shader)

        shader:send("u_projection", projection_matrix:to_vec4s())
        shader:send("u_view", camera:getTransform():to_vec4s())

        currentShader = shader
    end

    for model in pairs(scene.models) do
        if (model.shader ~= currentShader) then
            switchShader(model.shader)
        end

        currentShader:send("u_model", model:getTransform():to_vec4s())
        love.graphics.draw(model.mesh)
    end

    Lovegl.setShader()
    Lovegl.setDepthTest()
end

return Renderer
