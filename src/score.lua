function scores_update(dt)
    if not love.filesystem.getInfo("scores.lua") then
        scores = love.filesystem.newFile("scores.lua")
        --creates a new file to save scores if one does not already exist
    end
end

function save_score(score)
    love.filesystem.append("scores.lua", score.."\n")
    --records the attained score to "scores.lua" file
end
