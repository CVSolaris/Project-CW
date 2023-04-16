gamestate = require("libraries/gamestate")

---game states------------------------------
game = require("states/game")
menu = require("states/menu")

Player = {}

function love.load()
    gamestate.registerEvents()
    gamestate.switch(menu)
    --sets the prgram's initial state to the menu
end

function love.keypressed(key)
    if key == "backspace" then
        gamestate.push(game)
    end
    if key == "return" and gamestate.current() ~= menu then
        gamestate.pop()
    end
end
