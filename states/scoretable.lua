local scoretable = {}

local scores = {}

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function scoretable:enter()
    for lines in love.filesystem.lines("scores.lua") do
        table.insert(scores, lines)
        --inserts every saved score into the scores table
    end
end

function scoretable:keypressed(key)--testing that values were entered into table
    if key == "q" then
        for i, v in next, scores do
            print(i, v)
        end
    end
end

return scoretable