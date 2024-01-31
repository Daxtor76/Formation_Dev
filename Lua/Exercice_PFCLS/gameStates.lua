local gameState = {};

function NewGameState()
    gameState.state = "Playing";
    
    gameState.update = function()
        if gameState.state == "Playing" then
        elseif gameState.state == "End" then
        end
    end
end

return gameState;