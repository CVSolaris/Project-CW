require("libraries/windfield")

collision_classes = {}

function collision_classes:load()
    world:addCollisionClass("player")
    world:addCollisionClass("wall")
    world:addCollisionClass("enemy", {ignores = {"wall"}})
    world:addCollisionClass("heavy_enemy", {ignores = {"wall"}})
    world:addCollisionClass("bullet", {ignores = {"player", "bullet"}})
    world:addCollisionClass("dead", {ignores = {"enemy", "bullet"}})
end