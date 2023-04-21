local menu = {}
local buttons = {}

function newButton(text, unsel, fn)
    --creates a new button
    return {
        text = text,
        --determines what the button will say
        unsel = unsel,
        --determines what the button will appear as when not selected
        fn = fn
        --determines what the button will do...
        --...upon being pressed
    }
end

function exit_game()
    love.event.quit(0)
    --closes the program
end

function menu:enter() --loads menu data
    love.mouse.setVisible(true)
    --makes mouse visible

    menu:destroyButtons()
    --destroys previous buttons

    evolve = love.graphics.newImage("sprites/evolve.png")
    play = love.graphics.newImage("sprites/play.png")
    unsel_play = love.graphics.newImage("sprites/play_unsel.png")
    highscores = love.graphics.newImage("sprites/highscores.png")
    unsel_highscores = love.graphics.newImage("sprites/highscores_unsel.png")
    exit = love.graphics.newImage("sprites/exit.png")
    unsel_exit = love.graphics.newImage("sprites/exit_unsel.png")

    ---button creation----------------------------------------------------------------------
    table.insert(buttons, newButton(play, unsel_play, function() gamestate.switch(game) end))
    --starts the game
    table.insert(buttons, newButton(highscores, unsel_highscores, function() gamestate.push(scoretable) end))
    --loads the highscore table
    table.insert(buttons, newButton(exit, unsel_exit, function() exit_game() end))
    --closes the application
    ----------------------------------------------------------------------------------------
end

function menu:update(dt)
end

function menu:draw()
    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    local spacing = 0
    local gap = 70

    local mousex,mousey = love.mouse.getPosition()

    love.graphics.draw(evolve,(window_width / 2) - (evolve:getWidth() / 2), 100)



    for i = 1, #buttons do
        local button_h = play:getHeight()
        local image = buttons[i].text
        local button_w = image:getWidth()--obtains width of each button

        
        local total_button_height = (button_h + gap) * #buttons
        --finds the total height of all of the buttons

        local buttonx = (window_width / 2) - (button_w / 2)
        local buttony = (window_height / 2) - (total_button_height / 2) + spacing   

        local hovered = mousex > buttonx and mousex < buttonx + button_w and
                        mousey > buttony and mousey < buttony + button_h
            --true when mouse is over button

        if hovered then
            love.graphics.draw(buttons[i].text,
            (window_width / 2) - (button_w / 2),
            --centred on the screen
            (window_height / 2) - (total_button_height / 2) + spacing)
            --highlights the button when hovered over
        else
            love.graphics.draw(buttons[i].unsel,
            (window_width / 2) - (button_w / 2),
            --centred on the screen
            (window_height / 2) - (total_button_height / 2) + spacing)
            --draws regular unselected
        end

        spacing = spacing + (button_h + gap)
        --buttons will be drawn one after the other downwards
        
    end

    love.graphics.push("all")
    love.graphics.setColor(1,0,0,1)
    love.graphics.circle("fill", mousex, mousey, 5)
    --replacesmouse with cursor for the player to see
    love.graphics.pop()
    
end

function menu:mousepressed(x, y, button)

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
        local buttony = (window_height / 2) - (total_button_height / 2) + spacing  

        local hovered = mousex > buttonx and mousex < buttonx + button_w and
                        mousey > buttony and mousey < buttony + button_h
            --true when mouse is over button
        
        if button == 1 and hovered then
            buttons[i].fn()
        end

        spacing = spacing + (button_h + gap)
    end
end

function menu:destroyButtons()
    for i = #buttons, 1, -1 do
        table.remove(buttons, i)
        --destroys all buttons in the table
    end
end

return menu