local ffi = require "ffi"
local use_gles = false

local LoveGL = {}

function LoveGL.init()
    local already_loaded = pcall(function() return ffi.C.SDL_GL_DEPTH_SIZE end)
    if not already_loaded then
        ffi.cdef([[
            typedef enum {
                SDL_GL_DEPTH_SIZE = 6
            } SDL_GLattr;
            void *SDL_GL_GetProcAddress(const char *proc);
            int SDL_GL_GetAttribute(SDL_GLattr attr, int* value);
        ]])
    end

    -- Windows needs to use an external SDL
    local sdl
    if love.system.getOS() == "Windows" then
        if not love.filesystem.isFused() and love.filesystem.isFile("bin/SDL2.dll") then
            sdl = ffi.load("bin/SDL2")
        else
            sdl = ffi.load("SDL2")
        end
    else
        -- On other systems, we get the symbols for free.
        sdl = ffi.C
    end

    -- Get handles for OpenGL
    local opengl
    if select(1, love.graphics.getRendererInfo()) == "OpenGL ES" then
        use_gles = true
        opengl = require("libs.opengles2")
    else
        opengl = require("libs.opengl")
    end
    opengl.loader = function(fn)
        return sdl.SDL_GL_GetProcAddress(fn)
    end
    opengl:import()
end

--- Clear color/depth buffers.
-- Must pass false (not nil!) to disable clearing. Defaults to depth only.
-- @param color clear color buffer (bool)
-- @param depth clear depth buffer (bool)
function LoveGL.clear(color, depth)
    local to_clear = 0
    if color then
        to_clear = bit.bor(to_clear, tonumber(GL.COLOR_BUFFER_BIT))
    end
    if depth or depth == nil then
        to_clear = bit.bor(to_clear, tonumber(GL.DEPTH_BUFFER_BIT))
    end
    gl.Clear(to_clear)
end

--- Reset LOVE3D state.
-- Disables depth testing, enables depth writing, disables culling and resets
-- front face.
function LoveGL.reset()
    LoveGL.set_depth_test()
    LoveGL.set_depth_write()
    LoveGL.set_culling()
    LoveGL.set_front_face()
end

-- FXAA helpers
function LoveGL.getFxaaAlpha(color)
    local c_vec = cpml.vec3.isvector(color) and color or cpml.vec3(color)
    return c_vec:dot(cpml.vec3(0.299, 0.587, 0.114))
end

function LoveGL.setFxaaBackground(color)
    local c_vec = cpml.vec3.isvector(color) and color or cpml.vec3(color)
    love.graphics.setBackgroundColor(c_vec.x, c_vec.y, c_vec.z, LoveGL.get_fxaa_alpha(c_vec))
end

--- Set depth writing.
-- Enable or disable writing to the depth buffer.
-- @param mask
function LoveGL.setDepthWrite(mask)
    if mask then
        assert(type(mask) == "boolean", "set_depth_write expects one parameter of type 'boolean'")
    end
    gl.DepthMask(mask or true)
end

--- Set depth test method.
-- Can be "greater", "equal", "less" or unspecified to disable depth testing.
-- Usually you want to use "less".
-- @param method
function LoveGL.setDepthTest(method)
    if method then
        local methods = {
            greater = GL.GEQUAL,
            equal = GL.EQUAL,
            less = GL.LEQUAL
        }
        assert(methods[method], "Invalid depth test method.")
        gl.Enable(GL.DEPTH_TEST)
        gl.DepthFunc(methods[method])
        if use_gles then
            gl.DepthRangef(0, 1)
            gl.ClearDepthf(1.0)
        else
            gl.DepthRange(0, 1)
            gl.ClearDepth(1.0)
        end
    else
        gl.Disable(GL.DEPTH_TEST)
    end
end

--- Set front face winding.
-- Can be "cw", "ccw" or unspecified to reset to ccw.
-- @param facing
function LoveGL.setFrontFace(facing)
    if not facing or facing == "ccw" then
        gl.FrontFace(GL.CCW)
        return
    elseif facing == "cw" then
        gl.FrontFace(GL.CW)
        return
    end

    error("Invalid face winding. Parameter must be one of: 'cw', 'ccw' or unspecified.")
end

--- Set culling method.
-- Can be "front", "back" or unspecified to reset to none.
-- @param method
function LoveGL.setCulling(method)
    if not method then
        gl.Disable(GL.CULL_FACE)
        return
    end

    gl.Enable(GL.CULL_FACE)

    if method == "back" then
        gl.CullFace(GL.BACK)
        return
    elseif method == "front" then
        gl.CullFace(GL.FRONT)
        return
    end

    error("Invalid culling method: Parameter must be one of: 'front', 'back' or unspecified")
end

function LoveGL.setShader(...)
    return love.graphics.setShader(...)
end

return LoveGL
