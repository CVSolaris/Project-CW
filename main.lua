require("src/player")
require("src/environment")
require("src/enemy")
require("src/bar")

function love.load()
    bar:load()
    spawn_timer = 2
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
end

function love.update(dt)
    bar:update(dt)
    world:update(dt)
    --^ensures any changes that occur to the objects in the world occur in real time
    Player:update(dt)
    --^makes any triggered changes to the player in real time
    enemies:update(dt)
    wave_system(dt)
    Projectiles:update(dt)
    Projectiles:deload()

end

function love.draw()
    environment:draw()
    --draws the background
    enemies:draw()
    --draws the enemies
    Player:draw()
    --draws the player
    Projectiles:draw()
    --whichever is drawn last will always be on top
    --world:draw()
    bar:draw()
end

function wave_system(dt)
    local total_enemies = 0
    --initialised the enemy count to 0
    wave_number = 1
    --initialises wave count to 1
    spawn_timer = spawn_timer - dt
    --decrements the timer over time
    for _, enemies in ipairs(enemies) do
        total_enemies = total_enemies + 1
        --counts the amount of enemies
    end
    if spawn_timer < 0 then
        spawn_timer = 0
    end
    if total_enemies <= 20 then
        --ensures that no more than 50 enemies are spawned at once
        if spawn_timer <= 0 then
            --checks if timer is finished
            wave_number = wave_number + 1
            --increments wave count
            local total = love.math.random(5, 7)
            for i = 1, total do
                --repeats the creation of an enemy 5-7 times
                local x = love.math.random(0, 1920)
                --produces a random location along the x-axis
                local y = love.math.random(0, 1080)
                --produces a random location along the y-axis
                enemies:new(x, y)
            end
            spawn_timer = spawn_timer + 20
            --restarts the timer
        end
    end
end

function love.keypressed(key)
    if key == "z" then
        enemies:wipe()
        --destroys all enemies
    end
    if key == "1" then
        speed_up()
        overpowered()
    end
    if key == "2" then
        meleedmg_up()
    end
    if key == "3" then
        range_up()
    end
    if key == "4" then
        firerate_up()
    end
    if key == "5" then
        bulletsize_up()
    end
    if key == "6" then
        Player:reset()
    end
    if key == "q" then
        local x,y = love.mouse.getPosition()
        enemies:new(x, y)      
    end  
end
