anim8 = require ("libaries/anim8")
wf = require ("libaries/windfield")
require ("src/collision_classes")

enemies = {}

function enemies:new(x, y)
    --for testing purposes I can spawn an enemy where I want
    local rare_chance = love.math.random(0, 100)
    local size = 0
    local speed = 0
    local dmg = 0
    local remains_time
    local score
    if rare_chance <= 85 then
        -- 85% chance the enemy will be normal
        size = 40
        speed = 200
        exp_give = 80
        dmg = 3
        health = 160
        enemy_type = "enemy"
        remains_time = 2
        score = 100
    elseif rare_chance > 85 then
        -- 15% chance the enemy will be a "heavy"
        size = 60
        speed = 100
        exp_give = 200
        dmg = 8
        health = 250
        enemy_type = "heavy_enemy"
        remains_time = 10
        score = 170
    end

    local enemy = world:newCircleCollider(x, y, size)
    --creates a new collider
    enemy.x, enemy.y = enemy:getPosition()
    enemy.type = enemy_type
    enemy.size = size
    ---enemy sprites-----------------------------------------------------------------------------------
    enemy.sprite = love.graphics.newImage("sprites/norm_enemy.png")
    enemy.hvy_sprite = love.graphics.newImage("sprites/heavy_enemy.png")
    enemy.sprite:setFilter("nearest", "nearest")
    enemy.hvy_sprite:setFilter("nearest", "nearest")
    local normsheet = anim8.newGrid(35, 35, enemy.sprite:getWidth(), enemy.sprite:getHeight())
    local hvysheet = anim8.newGrid(35, 35, enemy.hvy_sprite:getWidth(), enemy.hvy_sprite:getHeight())
    ---------------------------------------------------------------------------------------------------

    ---normal enemy animations--------------------------------
    if enemy_type == "enemy" then
        enemy.default = anim8.newAnimation(normsheet(1,1),1)
        enemy.north = anim8.newAnimation(normsheet(2,2),1)
        enemy.east = anim8.newAnimation(normsheet(1,3),1)
        enemy.south = anim8.newAnimation(normsheet(3,3),1)
        enemy.west = anim8.newAnimation(normsheet(2,4),1)
        enemy.northeast = anim8.newAnimation(normsheet(3,2),1)
        enemy.southeast = anim8.newAnimation(normsheet(2,3),1)
        enemy.southwest = anim8.newAnimation(normsheet(1,4),1)
        enemy.northwest = anim8.newAnimation(normsheet(3,4),1)
        enemy.stunned = anim8.newAnimation(normsheet(2,1),1)
        enemy.death = anim8.newAnimation(hvysheet(1,2),1)
    ---heavy enemy animations---------------------------------
    elseif enemy_type == "heavy_enemy" then
        enemy.default = anim8.newAnimation(hvysheet(1,1),1)
        enemy.north = anim8.newAnimation(hvysheet(1,2),1)
        enemy.east = anim8.newAnimation(hvysheet(3,2),1)
        enemy.south = anim8.newAnimation(hvysheet(2,3),1)
        enemy.west = anim8.newAnimation(hvysheet(1,4),1)
        enemy.northeast = anim8.newAnimation(hvysheet(2,2),1)
        enemy.southeast = anim8.newAnimation(hvysheet(1,3),1)
        enemy.southwest = anim8.newAnimation(hvysheet(3,3),1)
        enemy.northwest = anim8.newAnimation(hvysheet(2,4),1)
        enemy.stunned = anim8.newAnimation(hvysheet(2,1),1)
        enemy.death = anim8.newAnimation(hvysheet(3,1),1)
    end
    ----------------------------------------------------------
    enemy.dead = false
    enemy.score_give = score
    enemy.remains_timer = remains_time
    enemy.animation = enemy.default
    --initialises enemy frame to default sprite
    enemy.speed = speed
    --sets the speed of the enemy depending on its "type"
    enemy.base_hp = health * (1.2^ wave_number)
    --sets the enemy's health depending on wave count
    enemy.touch = false
    --initialises the enemy to be untouched
    enemy.timer = 0
    --creates a new enemy collider
    enemy.exp = exp_give
    --sets how much exp the enemy gives to the player
    enemy.dmg = dmg * (1.1^ Player.level)
    --sets how much dmg the enemy does to the player
    enemy:setCollisionClass(enemy_type)

    function enemy:hit(damage)
        local dmg = damage
        self.base_hp = self.base_hp - dmg
        --reduces the enemy health when hit
    end

    table.insert(enemies,enemy)
    --adds the newly made collider to the enemies table

end

function enemies:wipe()
    for i = #enemies,1 ,-1 do
        enemies[i]:destroy()
        --destroys the enemy's collider
        table.remove(enemies, i)
        --removes the enemy from
    end
end

function enemies:update(dt)
    table.sort(enemies, function(x, y) return x:getY() > y:getY() end)
    --sorts the enemies based on their positions along the y-axis
    for i = #enemies,1 ,-1 do
        if enemies[i].touch == false and enemies[i].dead == false then
            local user_x, user_y = Player:getPosition()
            local enemy_x, enemy_y = enemies[i]:getPosition()
            local angle = math.atan2(enemy_y - user_y, user_x - enemy_x)

            local x_dir = math.cos(angle) * enemies[i].speed
            --uses the angle between the player and the enemy...
            --...to determine the speed in the x-axis
            local y_dir = math.sin(angle) * enemies[i].speed
            --uses the angle between the player and the enemy...
            --...to determine the speed in the y-axis
            enemies[i]:setLinearVelocity(x_dir,-1 * y_dir)
            if angle >= -0.39269 and angle <= 0.39269 then
                enemies[i].east:update(dt)
                enemies[i].animation = enemies[i].east
            elseif angle >= 0.39269 and angle <= 1.17809 then
                enemies[i].northeast:update(dt)
                enemies[i].animation = enemies[i].northeast
            elseif angle >= 1.17809 and angle <= 1.96349 then
                enemies[i].north:update(dt)
                enemies[i].animation = enemies[i].north
            elseif angle >= 1.96349 and angle <= 2.74889 then
                enemies[i].northwest:update(dt)
                enemies[i].animation = enemies[i].northwest
            elseif angle >= 2.74889 or angle <= -2.74889 then
                enemies[i].west:update(dt)
                enemies[i].animation = enemies[i].west
            elseif angle <= -0.39269 and angle >= -1.17809 then
                enemies[i].southeast:update(dt)
                enemies[i].animation = enemies[i].southeast
            elseif angle <= -1.17809 and angle >= -1.96349 then
                enemies[i].south:update(dt)
                enemies[i].animation = enemies[i].south
            elseif angle <= -1.96349 and angle >= -2.74889 then
                enemies[i].southwest:update(dt)
                enemies[i].animation = enemies[i].southwest
            end 
        else
            enemies[i].animation = enemies[i].stunned
            --whenever hit the enemy appears stunned
            enemies[i].timer = enemies[i].timer - dt
            --decrements timer over time
            if enemies[i].timer <= 0 then
                --checks if the timer has depleted
                enemies[i].touch = false
               --reverts the enemy's state to homing in on the player
            end
        end
        if enemies[i].base_hp <= 0 and enemies[i].touch == false then
            --checks if the enemy is still "touched" so that the knockback will still occur
            local x, y = enemies[i]:getPosition()
            enemies[i].dead = true
            --checks if the enemy is dead
            enemies[i]:setCollisionClass("dead")
            --changes the collision class of the now-dead enemy...
            --so that it won't collide with the player
            enemies[i].animation = enemies[i].death
            --changes the appearance of the enemy to the dead sprite
            enemies[i]:setLinearVelocity(0,0)
            enemies[i].remains_timer = enemies[i].remains_timer - dt
            --allows the dead enemy to remain on screen for a few seconds before disappearing
        end 
        if enemies[i].animation == enemies[i].death and enemies[i].remains_timer <= 0 then
            Player.totalexp = Player.totalexp + enemies[i].exp
            --gives the player the exp dropped by the enemy
            Player.score = Player.score + enemies[i].score_give
            --increases the player's score depending on the enemy killed
            print("Current score:", Player.score)
            --gives the player the appropriate exp
            enemies[i]:destroy()
            --destroys the collider
            table.remove(enemies, i)
            --destroys the object in the table
            print("exp : ", Player.totalexp)
        end
    end
end
    
function enemies:draw()
    for i = #enemies, 1, -1 do
        local sprite
        local x, y = enemies[i]:getPosition()
        --gets position of enemy collider
        if enemies[i].type == "enemy" then
            sprite = enemies[i].sprite
        else
            sprite = enemies[i].hvy_sprite
        end
        enemies[i].animation:draw(sprite, x, y, 0, 0.1 * enemies[i].size, 0.1 * enemies[i].size, 17,17) 
    end
end