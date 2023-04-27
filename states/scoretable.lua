local scoretable = {}
local buttons = {}
local scores = {}

function scoretable:destroyButtons()
    for i = #buttons, 1, -1 do
        table.remove(buttons, i)
        --destroys all buttons in the table
    end
end

function scoretable:enter()

    scores = {}

    for lines in love.filesystem.lines("scores.lua") do
        table.insert(scores, tonumber(lines))
        --inserts every saved score into the scores table
    end



    table.sort(scores, function(x, y) return x > y end)
    --sorts the table in descending order

    for i = #scores, 1, -1 do
        print(scores[i]) --testing purposes
    end

    love.mouse.setVisible(true)
    --makes mouse visible

    scoretable:destroyButtons()
    --destroys previous buttons

    highscores_title = love.graphics.newImage("sprites/highscores_title.png")
    return_ = love.graphics.newImage("sprites/return.png")
    unsel_return = love.graphics.newImage("sprites/return_unsel.png")

    ---button creation----------------------------------------------------------------------
    table.insert(buttons, newButton(return_, unsel_return, function() gamestate.pop() end))
    --starts the game
    ----------------------------------------------------------------------------------------
end

function scoretable:update(dt)
    table.sort(scores, function(x, y) return x > y end)
    --sorts the table in descending order
end

function scoretable:draw()
    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    local mousex,mousey = love.mouse.getPosition()

    love.graphics.draw(highscores_title,(window_width / 2) - (highscores_title:getWidth() / 2), 100)

    for i = 1, #buttons do

        local spacing = 0
        local gap = 70

        buttons.last = buttons.now --resets the mouse's state

        local button_h = play:getHeight()
        local image = buttons[i].text
        local button_w = image:getWidth()--obtains width of each button

        
        local total_button_height = (button_h + gap) * #buttons
        --finds the total height of all of the buttons

        local buttonx = (window_width / 2) - (button_w / 2)
        local buttony = (window_height / 2) - (total_button_height / 2) + 400 + spacing   

        local hovered = mousex > buttonx and mousex < buttonx + button_w and
                        mousey > buttony and mousey < buttony + button_h
            --true when mouse is over button

        if hovered then
            love.graphics.draw(buttons[i].text,
            (window_width / 2) - (button_w / 2),
            --centred on the screen
            (window_height / 2) - (total_button_height / 2) + 400 + spacing)
            --highlights the button when hovered over
        else
            love.graphics.draw(buttons[i].unsel,
            (window_width / 2) - (button_w / 2),
            --centred on the screen
            (window_height / 2) - (total_button_height / 2) + 400 + spacing)
            --draws regular unselected
        end

        spacing = spacing + (button_h + gap)
        --buttons will be drawn one after the other downwards
        
    end

    local next_one = 0

    if #scores >= 5 then

        for i = 1, 5 do --top 5 scores

            love.graphics.setFont(finalfont)
            --sets font
            love.graphics.print(i,(window_width / 2) - (highscores_title:getWidth() / 2) + 200, 250 + next_one)
            --prints no. ranking of scores
            love.graphics.print(scores[i], (window_width / 2) - (highscores_title:getWidth() / 2) + 600, 250 + next_one)
            --prints scores alongside rankings
            next_one = next_one + 120
            --ensures that next score is a set increment down from the previous

        end

    else --if less than 5 scores saved

        for i = 1, 5 do --top 5 scores

            love.graphics.setFont(finalfont)
            --sets font
            love.graphics.print(i,(window_width / 2) - (highscores_title:getWidth() / 2) + 200, 250 + next_one)
            --prints no. ranking of scores
            next_one = next_one + 120
            --ensures that next score is a set increment down from the previous
        end

        next_one = 0

        for i = 1, #scores do
            love.graphics.print(scores[i], (window_width / 2) - (highscores_title:getWidth() / 2) + 600, 250 + next_one)
            --prints scores alongside rankings
            next_one = next_one + 120
            --ensures that next score is a set increment down from the previous
        end
    end
end

function scoretable:mousepressed(x, y, button)

    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    local mousex,mousey = love.mouse.getPosition()

    local spacing = 0
    local gap = 70

    for i = 1, #buttons do

        local button_h = play:getHeight()
        local image = buttons[i].text
        local button_w = image:getWidth()

        local total_button_height = (button_h + gap) * #buttons

        local buttonx = (window_width / 2) - (button_w / 2)
        local buttony = (window_height / 2) - (total_button_height / 2) + 400 + spacing  

        local hovered = mousex > buttonx and mousex < buttonx + button_w and
                        mousey > buttony and mousey < buttony + button_h
            --true when mouse is over button
        
        if button == 1 and hovered then --checks if player clicked mb1
            buttons[i].fn()
        end

        spacing = spacing + (button_h + gap)
    end
end

return scoretable