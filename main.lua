require("player")

function love.load()
    world = wf.newWorld(0, 0, false)
    Player:load()
end

function love.update(dt)
    world:update(dt)
    Player:update()
end

function love.draw()
    Player:draw()
    world:draw()
end
