anim8 = require ("libraries/anim8")
wf = require ("libraries/windfield")
require ("src/collision_classes")
require ("src/projectiles")
require ("src/enemy")
require ("src/upgrades")
require ("src/score")

Player = {}

function Player:load()
    final_score = 0
    local x = love.graphics.getWidth() / 2 
    local y = love.graphics.getHeight() / 2 
    --obtains the midpoint of the program window
    Player = world:newCircleCollider(x, y, 30)
    Player:setCollisionClass("player")
    Player.sprite = love.graphics.newImage("sprites/template.red.png")
    Player.sprite:setFilter("nearest", "nearest")
    --loads in the player's spritesheet
    local spritesheet = anim8.newGrid(64, 64, Player.sprite:getWidth(), Player.sprite:getHeight())
    --breaks up the spritesheet into inidividual frames
    ---player spawnpoint--------------------------------------------------
    Player.spawn_x = x
    Player.spawn_y = y
    ---player stats-------------------------------------------------------
    Player.alive = true
    Player.stunned = false
    Player.stun_timer = 0
    Player.level = 1
    Player.totalexp = 0
    Player.upgradepoints = 0
    Player.speed = 500
    Player.direction = "down"
    Player.total_health = 200 * (1.2^ Player.level)
    Player.health = 200 * (1.2^ Player.level)
    Player.base_melee_dmg = 100
    Player.range = 65
    Player.firerate = 0.6
    Player.swingtime = 0.8
    Player.exp_threshold = 500 * (1.1 ^ Player.level)
    Player.score = 0
    melee_cooldown = 0
    ranged_cooldown = 0
    attacking = false
    ---idle animations----------------------------------------------------
    Player.idle_down = anim8.newAnimation(spritesheet('1-8',1), 0.25)
    Player.idle_up = anim8.newAnimation(spritesheet('1-8',3), 0.25)
    Player.idle_right = anim8.newAnimation(spritesheet('1-8',2), 0.25)
    Player.idle_left = anim8.newAnimation(spritesheet('1-8',4), 0.25)
    ---running animations-------------------------------------------------
    Player.run_down = anim8.newAnimation(spritesheet('1-8',9), (35 / Player.speed))
    Player.run_up = anim8.newAnimation(spritesheet('1-8',11), (35 / Player.speed))
    Player.run_right = anim8.newAnimation(spritesheet('1-8',10), (35 / Player.speed))
    Player.run_left = anim8.newAnimation(spritesheet('1-8',12), (35 / Player.speed))
    ---melee animations--------------------------------------------------
    Player.attack_down = anim8.newAnimation(spritesheet('1-5',13), 0.04)
    Player.attack_right = anim8.newAnimation(spritesheet('1-5',14), 0.04)
    Player.attack_up = anim8.newAnimation(spritesheet('1-5',15), 0.04)
    Player.attack_left = anim8.newAnimation(spritesheet('1-5',16), 0.04)
    ----------------------------------------------------------------------

    function Player:reset()
        final_score = 0
        wave_number = 1
        --changes player's stats to starting stats
        Player:setPosition(Player.spawn_x, Player.spawn_y)
        --moves the player back to the centre of the screen
        Player.alive = true
        Player.stunned = false
        Player.stun_timer = 0
        Player.level = 1
        Player.totalexp = 0
        Player.upgradepoints = 0
        Player.speed = 500
        Player.direction = "down"
        Player.score = 0
        melee_cooldown = 0
        ranged_cooldown = 0
        Player.total_health = 200 * (1.2^ Player.level)
        Player.health = 200 * (1.2^ Player.level)
        Player.base_melee_dmg = 100
        Player.range = 65
        Player.firerate = 0.6
        Player.swingtime = 0.8
        Projectiles.speed = 1000
        Projectiles.damage = 40
        Projectiles.size = 10
    end

    function Player:move(dt)
        local xvelo, yvelo = 0, 0
        if Player.stun_timer <= 0 then
            --checks if the timer has depleted
            Player.stun_timer = 0
            Player.stunned = false
        end
        ---player movement--------------------------------------------------------------
        if Player.stunned == false then
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
            if love.keyboard.isDown("w") and love.keyboard.isDown("s") then
                yvelo = 0
            end
            if love.keyboard.isDown("a") and love.keyboard.isDown("d") then
                xvelo = 0
            end
            Player:setLinearVelocity(xvelo, yvelo)
        end
        ---player knockback----------------------------------------------------
        for i = #enemies, 1, -1 do
            if Player:enter("enemy") or Player:enter("heavy_enemy") then
                local user_x, user_y = Player:getPosition()
                local enemy_x, enemy_y = enemies[i]:getPosition()
                local angle = math.atan2(enemy_y - user_y, user_x - enemy_x)
                --caculates angle between enemy and player
                local x_dir = math.cos(angle) * enemies[i].speed
                --uses the angle between the player and the enemy...
                --...to determine the speed in the x-axis
                local y_dir = math.sin(angle) * enemies[i].speed
                --uses the angle between the player and the enemy...
                --...to determine the speed in the y-axis
                Player.stunned = true
                Player.stun_timer = 0.2
                --determines how long the player will be knocked back for
                Player:setAngularVelocity(0)
                --stops the player from spinning
                Player:applyLinearImpulse(x_dir * 5 ,(-1 *y_dir) * 5)
                --applies knockback in the direction of the enemy's movement
            end
        end
        Player.stun_timer = Player.stun_timer - dt
        --decrements stun timer
    end
    
    function Player:melee()
        local damage = Player.base_melee_dmg
        if melee_cooldown < 0 then
            melee_cooldown = 0
            --ensures that the cooldown can never be < 0
        end
        if melee_cooldown <= 0.6 then
            attacking = false
            Player.attack_down:pauseAtEnd()
            --stops player animation at final frame
            Player.attack_up:pauseAtEnd()
            Player.attack_right:pauseAtEnd()
            Player.attack_left:pauseAtEnd()
        end
        if love.mouse.isDown(1) and melee_cooldown == 0 then
            --^checks if the M1 on the mouse has been pressed down
            attacking = true
            Player.attack_down:resume()
            --plays animation from first frame
            Player.attack_up:resume()
            Player.attack_right:resume()
            Player.attack_left:resume()
            local x, y = Player:getPosition()
            --^gets the position of the player collider at the moment M1 was pressed
            if Player.direction == "up" then
                y = y - 40 
            elseif Player.direction == "down" then
                y = y + 40
            elseif Player.direction == "left" then
                x = x - 40
            elseif Player.direction == "right" then 
                x = x + 40
            end
            local range = Player.range
            local enemies = world:queryCircleArea(x, y , range, {"enemy","heavy_enemy"})
            --^checks a circular area at the position of the player
            -- size determined by player range
            -- to see if a collider with the collider class "enemy" is there
            for i = #enemies, 1, -1 do
                enemies[i].touch = true
                enemies[i].timer = 0.2
                --starts timer
                --for each item returned by the query the following occurs:
                enemies[i]:setLinearVelocity(0, 0)
                enemies[i]:setAngularVelocity(0)
                --stops the movement of the enemy
                if Player.direction == "up" then
                    enemies[i]:applyLinearImpulse(0, -15000)
                    --knocks enemy upwards if player is facing upwards
                elseif Player.direction == "down" then
                    enemies[i]:applyLinearImpulse(0, 15000)
                    --knocks enemy downwards if player is facing downwards
                elseif Player.direction == "left" then
                    enemies[i]:applyLinearImpulse(-15000, 0)
                    --knocks enemy left 
                elseif Player.direction == "right" then 
                    enemies[i]:applyLinearImpulse(15000, 0)
                    --knocks enemy right
                end
                    enemies[i]:hit(damage)
            end
            melee_cooldown = melee_cooldown + Player.swingtime
        end
    end
    
    function relative_pos()
        --^This function is to find the relative position of the
        -- mouse to the player, allowing me to determine what way
        -- the player should be facing
        local x, y = love.mouse.getPosition()
        local player_x, player_y = Player:getPosition()
        local angle = math.atan2(player_y - y, x - player_x)
        --^This measures the angle between the position of the
        -- player and the mouse
        return(angle)
        --^Allows me to use the angle of the mouse from the
        --  player in other functions
    end
    
    function Player:ranged_attack()
        local damage = Projectiles.damage
        if ranged_cooldown < 0 then
            ranged_cooldown = 0
            --ensures that the cooldown can never be < 0
        end
        local x, y = Player:getPosition()
        local dir = relative_pos()
        local x_dir = math.cos(dir) * Projectiles.speed
        --uses the angle between the player and the mouse...
        --...to determine the speed in the x-axis
        local y_dir = math.sin(dir) * Projectiles.speed
            --uses the angle between the player and the mouse...
        --...to determine the speed in the y-axis
        if love.mouse.isDown(2) and ranged_cooldown == 0 then
            local bullet = world:newCircleCollider(x, y, Projectiles.size)
            bullet.lifespan = 2
            --creates a new bullet
            bullet:setCollisionClass("bullet")
            --sets every object to be "bullet"
            bullet:setLinearVelocity(x_dir,-1 * y_dir)
            --determines the travel speed and direction of the bullet
            table.insert(Projectiles, bullet)
            --inserts the new collider in the projectile table
            ranged_cooldown = ranged_cooldown + Player.firerate
            --stops the player from firing another projectile until...
            --...0.6 seconds have passed
        end
        for i = #enemies,1 ,-1 do
            --checks for all enemies
            if enemies[i]:enter("bullet") then
                enemies[i].touch = true
                enemies[i].timer = 0.15
                --starts 0.1 second timer
                --checks if an enemy touches a bullet
                enemies[i]:setLinearVelocity(0,0)
                --stops the enemy from moving
                enemies[i]:setAngularVelocity(0)
                --stops the enemy from spinning
                enemies[i]:applyLinearImpulse(x_dir * 4,(-1 * y_dir) * 4)
                --applies knockback in the direction of the projectile travel
                enemies[i]:hit(damage)
                --deals damage to that enemy
            end
        end
    end

    function Player:hit()
        local dir = relative_pos()
        --check the angle between enemy and the player
        local x_dir = math.cos(dir) * Projectiles.speed
        --uses the angle between the player and the mouse...
        --...to determine the speed in the x-axis
        local y_dir = math.sin(dir) * Projectiles.speed
            --uses the angle between the player and the mouse...
        --...to determine the speed in the y-axis
        for i = #enemies, 1, -1 do
            if Player:enter("enemy") or Player:enter("heavy_enemy") then
                --checks if the player collider touches an enemy
                Player.health = Player.health - enemies[i].dmg
                --deals the appropriate ammount of damage
            end
        end
        if Player.health <= 0 then
            print("Player is dead")
            final_score = Player.score
            gamestate.switch(gameover, final_score)--loads game over screen
            --passes final score to gameover state to save
        end
    end
    
    function player_dir()
        local angle = math.deg(relative_pos())
        --changes the angle to degrees
        if -45 <= angle and angle <= 45 then
            Player.direction = "right"
        elseif -180 <= angle and angle <= -136 or 136 <= angle and angle <= 180 then
            Player.direction = "left"
        elseif 46 <= angle and angle <= 135 then
            Player.direction = "up"
        elseif -135 <= angle and angle <= -46 then
            Player.direction = "down"
        end
    end

    function Player:upgrade(x)
        if x == 1 then
            speed_up()
        elseif x == 2 then
            meleedmg_up()
        elseif x == 3 then
            range_up()
        elseif x == 4 then
            firerate_up()
        elseif x == 5 then
            bulletsize_up()
        end
    end
    
    function Player:levelup()
        --sets how much exp the player needs to level up
        --increases exponentially
        local overexp = 0
        --initialises how much exp over the threshold the player obtains
        if Player.totalexp == Player.exp_threshold then
            Player.level = Player.level + 1
            Player.upgradepoints = Player.upgradepoints + 1
            Player.totalexp = 0
            print("The player's level is ", Player.level)
            --increments the player's level by 1 if the threshold is met
            Player.total_health = 200 * (1.2^ Player.level)
            --increases player's total health
            Player.health = Player.total_health
            --gives player full health again
            local number = love.math.random(1,5)
            --decides which upgrade is obtained randomly
            Player:upgrade(number)
        elseif Player.totalexp > Player.exp_threshold then
            overexp = Player.totalexp - Player.exp_threshold
            Player.level = Player.level + 1
            Player.upgradepoints = Player.upgradepoints + 1
            Player.totalexp = overexp
            print("The player's level is ", Player.level)
            --increments the player's level by 1 and adds any extra exp...
            --...so that the player does not lose experience points
            Player.total_health = 200 * (1.2^ Player.level)
            --increases player's total health
            Player.health = Player.total_health
            --gives player full health again
            local number = love.math.random(1,5)
            --decides which upgrade is obtained randomly
            Player:upgrade(number)
        end
    end

    function Player:animations(dt)
        local x ,y = Player:getLinearVelocity()
        if attacking == false then
        -------idle animation----------------------------
            if x == 0 and y == 0 then
                if Player.direction == "down" then
                    --^starts animation from beginning
                    Player.idle_down:update(dt)
                    animation = Player.idle_down
                elseif Player.direction == "up" then
                    Player.idle_up:update(dt)
                    animation = Player.idle_up
                elseif Player.direction == "right" then
                    Player.idle_right:update(dt)
                    animation = Player.idle_right
                elseif Player.direction == "left" then
                    Player.idle_left:update(dt)
                    animation = Player.idle_left
                end
        -------running animations------------------------
            elseif x == 0 and y < 0 then
                Player.run_up:update(dt)
                animation = Player.run_up
            elseif x == 0 and y > 0 then
                Player.run_down:update(dt)
                animation = Player.run_down
            elseif x < 0 then
                Player.run_left:update(dt)
                animation = Player.run_left
            elseif x > 0 then
                Player.run_right:update(dt)
                animation = Player.run_right
            end
        -------attacking animations----------------------
        elseif attacking == true then
            if Player.direction == "down" then
                Player.attack_down:update(dt)
                animation = Player.attack_down
            elseif Player.direction == "up" then
                Player.attack_up:update(dt)
                animation = Player.attack_up
            elseif Player.direction == "right" then
                Player.attack_right:update(dt)
                animation = Player.attack_right
            elseif Player.direction == "left" then
                Player.attack_left:update(dt)
                animation = Player.attack_left
            end
        end
    end

    function Player:update(dt)
        scores_update(dt)
        player_dir()
        Player:animations(dt)
        melee_cooldown = melee_cooldown - dt
        ranged_cooldown = ranged_cooldown - dt
        Player:move(dt)
        Player:melee()
        Player:ranged_attack()
        Player:levelup()
        Player:hit()
    end

    function Player:draw()
        local x, y = Player:getPosition()
        animation:draw(Player.sprite, x, y, 0, 3, 3, 32, 30)
    end
end
