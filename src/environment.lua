anim8 = require ("libraries/anim8")
wf = require ("libraries/windfield")
require ("src/collision_classes")


environment = {} --creates a new table which will hold all of the colliders of the environment

function environment:load()
    background = love.graphics.newImage("sprites/background.png")
    --loads the background image
    background:setFilter("nearest", "nearest")
    --unblurs the image
    left_bound = world:newRectangleCollider(0, 0, 1, 1080)
    left_bound:setCollisionClass("wall")
    --sets the collider to have the class "wall"
    right_bound = world:newRectangleCollider(1919, 0, 1, 1080)
    right_bound:setCollisionClass("wall")
    top_bound = world:newRectangleCollider(0, 0, 1920, 1)
    top_bound:setCollisionClass("wall")
    bottom_bound = world:newRectangleCollider(0, 1079, 1920, 1)
    bottom_bound:setCollisionClass("wall")
    --these bounds ^ act as walls to stop the player
    left_bound:setType("static")
    right_bound:setType("static")
    top_bound:setType("static")
    bottom_bound:setType("static")
    --"static" ensures that the colliders do not move
end

function environment:draw()
    love.graphics.draw(background, 0, 0, 0, 10, 10)
end