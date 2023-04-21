local gameover = {}
local buttons = {}
local score2save = 0
local saved

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

function gameover:enter(game) --loads menu data

    saved = false

    if saved == false then
        save_score(final_score)--saves final score
        saved = true
    end

    love.mouse.setVisible(true)
    --makes mouse visible

    for i = #buttons, 1, -1 do
        table.remove(buttons, i)
        --destroys all buttons in the table
    end
    --destroys previous buttons

    gameover = love.graphics.newImage("sprites/gameover.png")
    play_again = love.graphics.newImage("sprites/play_again.png")
    unsel_play_again = love.graphics.newImage("sprites/play_again_unsel.png")
    main_menu = love.graphics.newImage("sprites/main_menu.png")
    unsel_main_menu = love.graphics.newImage("sprites/main_menu_unsel.png")
    exit = love.graphics.newImage("sprites/exit.png")
    unsel_exit = love.graphics.newImage("sprites/exit_unsel.png")
    save = love.graphics.newImage("sprites/save.png")
    unsel_save = love.graphics.newImage("sprites/save_unsel.png")
    saved = love.graphics.newImage("sprites/saved.png")

    ---button creation----------------------------------------------------------------------
    --table.insert(buttons, newButton(save, unsel_save, function() print("saved") end))
    --loads the save button
    table.insert(buttons, newButton(main_menu, unsel_main_menu, function() gamestate.switch(menu) end))
    --loads the highscore table
    table.insert(buttons, newButton(exit, unsel_exit, function() exit_game() end))
    --closes the application
    ----------------------------------------------------------------------------------------

end

function gameover:update(dt)
end

function gameover:draw()
    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    local spacing = 0
    local gap = 70

    local mousex,mousey = love.mouse.getPosition()

    love.graphics.draw(gameover,(window_width / 2) - (gameover:getWidth() / 2), 100)

    love.graphics.setFont(finalfont)
	love.graphics.setColor(1, 1, 1)
    love.graphics.print("final score: "..final_score, (window_width / 2) - (gameover:getWidth() / 2) + 30, 350)
    --prints score

    for i = 1, #buttons do
        buttons.last = buttons.now --resets the mouse's state

        local button_h = play:getHeight()
        local image = buttons[i].text
        local button_w = image:getWidth()--obtains width of each button

        
        local total_button_height = (button_h + gap) * #buttons
        --finds the total height of all of the buttons

        local buttonx = (window_width / 2) - (button_w / 2)
        local buttony = (window_height / 2) - (total_button_height / 2) + 200 + spacing   

        local hovered = mousex > buttonx and mousex < buttonx + button_w and
                        mousey > buttony and mousey < buttony + button_h
            --true when mouse is over button

        if hovered then
            love.graphics.draw(buttons[i].text,
            (window_width / 2) - (button_w / 2),
            --centred on the screen
            (window_height / 2) - (total_button_height / 2) + 200 + spacing)
            --highlights the button when hovered over
        else
            love.graphics.draw(buttons[i].unsel,
            (window_width / 2) - (button_w / 2),
            --centred on the screen
            (window_height / 2) - (total_button_height / 2) + 200 + spacing)
            --draws regular unselected
        end

        spacing = spacing + (button_h + gap)
        --buttons will be drawn one after the other downwards
        
    end
end

function gameover:mousepressed(x, y, button)

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
        local buttony = (window_height / 2) - (total_button_height / 2) + 200 + spacing  

        local hovered = mousex > buttonx and mousex < buttonx + button_w and
                        mousey > buttony and mousey < buttony + button_h
            --true when mouse is over button
        
        if button == 1 and hovered then --checks if player clicked mb1
            buttons[i].fn()
        end

        spacing = spacing + (button_h + gap)
    end
end

return gameover