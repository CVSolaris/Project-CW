anim8 = require ("libraries/anim8")
wf = require ("libraries/windfield")
require ("src/collision_classes")


Projectiles = {}

function Projectiles:load()
    Projectiles.speed = 1000
    Projectiles.damage = 60
    Projectiles.size = 10
    Projectiles.lifespan = 0
    Projectiles.sprite = love.graphics.newImage("sprites/bullet.png")
    --loads the spritesheet
    Projectiles.sprite:setFilter("nearest", "nearest")
    local spritesheet = anim8.newGrid(32, 32, Projectiles.sprite:getWidth(), Projectiles.sprite:getHeight())
    --splits the spritesheet into separate frames
    Projectiles.animation = anim8.newAnimation(spritesheet('1-3',1), 0.30)
    --loads the animation for the bullets

    function Projectiles:deload()
        for i = #Projectiles, 1, -1 do
            if Projectiles[i]:enter("wall") or Projectiles[i]:enter("enemy") then
                --checks if a bullet touches an enemy or wall
                Projectiles[i]:destroy()
                --unloads the bullet
                table.remove(Projectiles, i)
                --removes object from the table
            elseif Projectiles[i].lifespan <= 0 then
                --checks if the lifespan of the bullet has ended
                Projectiles[i]:destroy()
                --unloads the bullet
                table.remove(Projectiles, i)
            end
        end
    end

    function Projectiles:update(dt)
        for i = #Projectiles, 1, -1 do
            Projectiles[i].lifespan = Projectiles[i].lifespan - dt
            Projectiles.animation:update(dt)
        end
    end

    function Projectiles:draw()
        for i = #Projectiles, 1, -1 do
            local x, y = Projectiles[i]:getPosition()
            --gets the position of the projectile collider
            local xvel, yvel = Projectiles[i]:getLinearVelocity()
            local angle = math.atan2(yvel, xvel)
            --calculates how much the bullet needs to be rotated by
            Projectiles.animation:draw(Projectiles.sprite, x, y, angle, 0.3 * Projectiles.size, 0.3 * Projectiles.size, 16, 16)
            --draws the bullet animation "onto" the bullet collider
        end
    end
end

