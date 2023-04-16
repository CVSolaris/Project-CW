buttons = {}

function newButton(text, fn)
    --creates a new button
    return {
        text = text,
        --determines what the button will say
        fn = fn
        --determines what the button will do...
        --...upon being pressed
    }
end

function exit_game()
    love.event.quit(0)
    --closes the program
end

function buttons:load()
    buttons.width = 300
    buttons.height = 40
    ---button creation--------------------------------------------------------------
    table.insert(buttons, newButton("Start", gamestate.push(game)))
    --starts the game
    --table.insert(buttons, newButton("Highscores", gamestate.switch(highscores)))
    --loads the highscore table
    table.insert(buttons, newButton("Exit game", exit_game()))
    --closes the application
end

