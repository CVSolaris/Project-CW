local pause = {}
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

function pause:enter()
    love.mouse.setVisible(true)

    pause:destroyButtons()
    --destroys previous buttons
    font = love.graphics.newFont(32)
    --loads font size for the text in the buttons
    paused = love.graphics.newImage("sprites/paused.png")
    resume = love.graphics.newImage("sprites/resume.png")
    unsel_resume = love.graphics.newImage("sprites/resume_unsel.png")
    leave = love.graphics.newImage("sprites/leave.png")
    unsel_leave = love.graphics.newImage("sprites/leave_unsel.png")

    ---button creation----------------------------------------------------------------------
    table.insert(buttons, newButton(resume, unsel_resume, function() love.mouse.setVisible(false) gamestate.pop() end))
    --resumes the game / closes pause menu
    table.insert(buttons, newButton(leave, unsel_leave, function() gamestate.switch(menu) end))
    --returns to main menu
    ----------------------------------------------------------------------------------------
end

function pause:update(dt)
end

function pause:draw()

    environment:draw()

    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    local spacing = 0
    local gap = 70

    local mousex,mousey = love.mouse.getPosition()

    love.graphics.draw(paused,(window_width / 2) - (paused:getWidth() / 2), 100)

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

        local click = love.mouse.isDown(1)
            --checks if user clicks

        if hovered then
            love.graphics.draw(buttons[i].text,
            (window_width / 2) - (button_w / 2),
            --centred on the screen
            (window_height / 2) - (total_button_height / 2) + spacing)
            --highlights the button when hovered over
            if click then
                --if button clicked then function assigned to button will run
                buttons[i].fn()
            end
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
end

function pause:destroyButtons()
    for i = #buttons, 1, -1 do
        table.remove(buttons, i)
        --destroys all buttons in the table
    end
end

function pause:keypressed(key)
    if key == "escape" then
        love.mouse.setVisible(false)
        gamestate.pop()
    end
end

return pause