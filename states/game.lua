local game = {}

local tutorial_timer


function game:enter(previous) --loads data for the game to run
    wave_number = 0
    --initialises wave number
    love.keyboard.setKeyRepeat(false)--lets player hold down keys

    love.mouse.setVisible(false)
    --makes the mouse invisible
    Player:reset()
    --resets the player to the beginning
    enemies:wipe()
    --wipes all previously spawned enemies
    spawn_timer = 2
    --brief pause before enemies spawn
    tutorial_timer = 10
    --determines how long the controls stay on the screen
    controls = love.graphics.newImage("sprites/controls.png")
    controls:setFilter("nearest", "nearest")
    --loads controls image
end

function game:update(dt)
    bar:update(dt)
    world:update(dt)
    --^ensures any changes that occur to the objects in the world occur in real time
    Player:update(dt)
    --^makes any triggered changes to the player in real time
    enemies:update(dt)
    wave_system(dt)
    Projectiles:update(dt)
    Projectiles:deload()

    tutorial_timer = tutorial_timer - dt
    --counts down timer
end

function wave_system(dt)
    local total_enemies = 0
    --initialised the enemy count to 0
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
            spawn_timer = spawn_timer + 25
            --restarts the timer
        end
    end
end

function game:draw()
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
    local mousex,mousey = love.mouse.getPosition()

    love.graphics.push("all")
    love.graphics.setColor(1,0,0,1)
    love.graphics.circle("fill", mousex, mousey, 5)
    --replacesmouse with cursor for the player to see
    love.graphics.pop()

    love.graphics.push("all")
    love.graphics.setFont(pixelfont)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("lvl: "..Player.level, 450, 10) -- prints player's level
    love.graphics.print("score: "..Player.score, 1350, 10) -- prints player's score
    love.graphics.print("wave: "..wave_number, 200, 10) -- prints current wave no.
    love.graphics.pop()

    if tutorial_timer > 0 then
        love.graphics.draw(controls, 50, 810, 0, 2, 2)--draws controls
    end
end

return game