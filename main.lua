function love.load()
    Loader = require("loader")
    Loader.includeModules("libs",
        -- hump
        "class",
        "signal",
        "timer",
        "gamestate",
        -- cpml
        "color",
        "constants",
        "intersect",
        "mat4",
        "mesh",
        "octree",
        "quat",
        "simplex",
        "utils",
        "vec2",
        "vec3",
        -- iqm
        "iqm",
        -- opengl
        "lovegl")

    Core = Loader.includeNamespace("src.core", "renderer", "scene")
    Node = Loader.includeNamespace("src.node", "node", "camera", "model")
    States = Loader.includeNamespace("src.states", "default")

    Lovegl.init()

    Gamestate.registerEvents()
    Gamestate.switch(States.Default)
end
