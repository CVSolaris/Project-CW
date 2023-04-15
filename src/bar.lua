require("src/player")

bar = {}

function bar:load()
    bar.hp_length = 700
    --sets the total length of hp bar
    bar.hp_height = 20
    --sets the height of hp bar
    bar.exp_length = 700
    --sets total length of exp bar
    bar.exp_height = 7
    --sets height of exp bar
end

function bar:update(dt)
    remaining_ratio = Player.health / Player.total_health
    exp_ratio = Player.totalexp / Player.exp_threshold
    bar.hp_length = 700 * remaining_ratio
    --changes the length of the hp bar depending on player's health remaining
    bar.exp_length = 700 * exp_ratio


end

function bar:draw()
    love.graphics.setColor(0.3, 0, 0, 1)
    love.graphics.rectangle("fill", 610, 0, 700, 20)
    love.graphics.setColor(0.7, 0, 0, 1)
    love.graphics.rectangle("fill", 610, 0, bar.hp_length, bar.hp_height)
    --draws the health bar onto the screen
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 610, 20, 700, bar.exp_height)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 610, 20, bar.exp_length, bar.exp_height)
end