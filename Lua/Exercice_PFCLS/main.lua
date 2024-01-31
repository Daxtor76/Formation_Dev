-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("gameStates");

screenWidth = love.graphics.getWidth();
screenHeight = love.graphics.getHeight();

local gameState = NewGameState();
local Symbol = require("symbol");

symbols = {};

function love.load()
    symbols = PopulateSymbols(5, 5, 5, 5, 5);
    symbolsCount = CountSurvivorsByType(symbols);
end

function love.update(dt)
    gameState.Update(dt);
end

function love.draw()
    gameState.Draw();
end

function love.keypressed(key)
end

function CountSurvivorsByType(entities)
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

function PopulateSymbols(lizardsAmount, papersAmount, rocksAmount, scissorsAmount, spocksAmount)
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