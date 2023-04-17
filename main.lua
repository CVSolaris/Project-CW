gamestate = require("libraries/gamestate")

require("src/player")
require("src/environment")
require("src/enemy")
require("src/bar")

---game states------------------------------
game = require("states/game")
menu = require("states/menu")

function love.load()
    gamestate.registerEvents()
    gamestate.switch(menu)
    bar:load()
    --starts the timer when starting the game
    world = wf.newWorld(0, 0, false)
    world:setQueryDebugDrawing(true)
    collision_classes:load()
    Player:load()
    --^loads the player
    environment:load()
    --^loads the objects in the environment#
    Projectiles:load()
    --^loads the projectile class
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
