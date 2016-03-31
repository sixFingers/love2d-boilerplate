Gamestate = require("libs.hump.gamestate")

State = require("src.states.state")

function love.load()

    Gamestate.registerEvents()
    Gamestate.switch(State)
end
