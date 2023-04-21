gamestate = require("libraries/gamestate")

require("src/player")
require("src/environment")
require("src/enemy")
require("src/bar")

---game states------------------------------
game = require("states/game")
menu = require("states/menu")
pause = require("states/pause")
scoretable = require("states/scoretable")
gameover = require("states/gameover")

function love.load()

    pixelfont = love.graphics.newFont("fonts/pixeboy.ttf", 60)
    finalfont = love.graphics.newFont("fonts/pixeboy.ttf", 100)

    love.mouse.setVisible(false)
    --hides the user's mouse
    gamestate.registerEvents()
    gamestate.switch(menu)
    bar:load()
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
    if key == "escape" then
        if gamestate.current() == game then
            gamestate.push(pause)
        end
    end
end
