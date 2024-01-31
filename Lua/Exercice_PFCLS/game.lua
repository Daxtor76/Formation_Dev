require("appStates");
local Symbol = require("symbol");

symbols = {};
symbolsCount = {};

function NewGameState()
    local game = {};

    game.Load = function()
        symbols = game.PopulateSymbols(5, 5, 5, 5, 5);
        symbolsCount = game.CountSurvivorsByType(symbols);
    end
    
    game.Update = function(dt)
        if appState.state == "Playing" then
            -- Symbols update
            for index, value in ipairs(symbols) do
                value.Update(dt);
            end            
        end

        -- Check End Game conditions
        if game.IsGameFinished() then
            appState.state = "End";
        else
            appState.state = "Playing";
        end
    end

    game.Draw = function()
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
        if appState.state == "End" then
            love.graphics.print(game.GetWinnerType().." Wins!", screenWidth*0.5, screenHeight*0.5);
        end
    end
    
    game.PopulateSymbols = function(lizardsAmount, papersAmount, rocksAmount, scissorsAmount, spocksAmount)
        local symbols = {}
        local total = lizardsAmount + papersAmount + rocksAmount + scissorsAmount + spocksAmount;
        for i=1, total do
            local symbol = nil;
            if i <= lizardsAmount then
                symbol = Symbol:New("Lizard", i);
            elseif i <= lizardsAmount + papersAmount then
                symbol = Symbol:New("Paper", i);
            elseif i <= lizardsAmount + papersAmount + rocksAmount then
                symbol = Symbol:New("Rock", i);
            elseif i <= lizardsAmount + papersAmount + rocksAmount + scissorsAmount then
                symbol = Symbol:New("Scissors", i);
            elseif i <= total then
                symbol = Symbol:New("Spock", i);
            end
            symbols[i] = symbol;
        end
        return symbols;
    end

    game.CountSurvivorsByType = function(entities)
        local countTable = {};
    
        for i=1, #entities do
            if countTable[entities[i].type] == nil then
                countTable[entities[i].type] = 1;
            else
                countTable[entities[i].type] = countTable[entities[i].type] + 1;
            end
        end
    
        return countTable;
    end

    game.GetWinnerType = function()
        if game.IsGameFinished() then
            for key, value in pairs(symbolsCount) do
                if value > 0 then
                    return key;
                end
            end
        end
    end

    game.IsGameFinished = function()
        local survivorsTypeCount = 0;
        for key, value in pairs(symbolsCount) do
            if value > 0 then
                survivorsTypeCount = survivorsTypeCount + 1;
            end
        end

        return survivorsTypeCount == 1;
    end

    game.Reset = function()
        symbols = {};
        symbolsCount = {};
        game.Load();
        appState.state = "Playing";
    end

    return game;
end
