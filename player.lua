anim8 = require ("libaries/anim8")
wf = require ("libaries/windfield")

Player = {}

function Player:load() 
    Player.x = love.graphics.getWidth() / 2  
    Player.y = love.graphics.getHeight() / 2 
    player = world:newCircleCollider(Player.x, Player.y, 30)
    Player.speed = 500
    Player.height = 30
    Player.width = 30

end

function Player:update(dt)
    Player:move(dt)
    Player:checkBoundaries()
end

function Player:move(dt)  
    --[[if love.keyboard.isDown("w") then
        Player.y = Player.y - Player.speed * dt
    end
    if love.keyboard.isDown("s") then
        Player.y = Player.y + Player.speed * dt
    end
    
    if love.keyboard.isDown("a") then
        Player.x = Player.x - Player.speed * dt
    end
    if love.keyboard.isDown("d") then
        Player.x = Player.x + Player.speed * dt
    end]]
    xvelo, yvelo = 0, 0
    if love.keyboard.isDown("w") then
        yvelo = Player.speed * -1
    end
    if love.keyboard.isDown("s") then
        yvelo = Player.speed
    end
    if love.keyboard.isDown("a") then
        xvelo = Player.speed * -1
    end
    if love.keyboard.isDown("d") then
        xvelo = Player.speed
    end

    if xvelo ~= 0 and yvelo ~= 0 then
        xvelo = xvelo / math.sqrt(2)
        yvelo = yvelo / math.sqrt(2)
    end

    player:setLinearVelocity(xvelo, yvelo)
end

function Player:checkBoundaries() 
    if Player.y < 0 then
        player:setLinearVelocity(xvelo, 0)
    end
    if Player.y + Player.height > love.graphics.getHeight() then
        player:setLinearVelocity(xvelo, 0)
    end
    if Player.x < 0 then
        player:setLinearVelocity(0, yvelo)
    end
    if Player.x + Player.width > love.graphics.getWidth() then
        player:setLinearVelocity(0, yvelo)
    end
end

function Player:draw()
end