local gameState = {};

function NewGameState()
    gameState.state = "Playing";
    
    gameState.Update = function(dt)
        if gameState.state == "Playing" then
            -- Symbols update
            for index, value in ipairs(symbols) do
                value.Update(dt);
            end            
        end

        -- Check End Game conditions
        if gameState.IsGameFinished() then
            gameState.state = "End";
        else
            gameState.state = "Playing";
        end
    end

    gameState.Draw = function()
        -- Symbols rendering
        for index, value in ipairs(symbols) do
            value.Draw();
        end
    
        -- Display survivors counts
        local scoreDisplayOffset = 0
        for key, value in pairs(symbolsCount) do
            scoreDisplayOffset = scoreDisplayOffset + 15;
            love.graphics.print(key.." : "..value, 10, 10 + scoreDisplayOffset);
        end

        -- Winner message display
        if gameState.state == "End" then
            love.graphics.print(gameState.GetWinnerType().." Wins!", screenWidth*0.5, screenHeight*0.5);
        end
    end

    gameState.GetWinnerType = function()
        if gameState.IsGameFinished() then
            for key, value in pairs(symbolsCount) do
                if value > 0 then
                    return key;
                end
            end
        end
    end

    gameState.IsGameFinished = function()
        local survivorsTypeCount = 0;
        for key, value in pairs(symbolsCount) do
            if value > 0 then
                survivorsTypeCount = survivorsTypeCount + 1;
            end
        end

        return survivorsTypeCount == 1;
    end

    return gameState;
end
