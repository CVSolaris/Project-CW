require("src/buttons")

menu = {}

function menu:enter() --loads menu data
    font = love.graphics.newFont(32)
    --loads font size for the text in the buttons
    --buttons:load()
    --loads the menu buttons
    evolve = love.graphics.newImage("sprites/evolve.png")
end

function menu:update(dt)
end

function menu:draw()
    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()
    local button_width = 350

    local evolve_width = evolve:getWidth()

    love.graphics.draw(evolve,(window_width / 2) - (evolve_width / 2), 15)

    --[[for i = #buttons, 1, -1 do
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", (window_width / 2) - (button_width / 2), (window)]]
end

return menu