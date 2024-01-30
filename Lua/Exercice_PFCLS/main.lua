-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

screenWidth = love.graphics.getWidth();
screenHeight = love.graphics.getHeight();

local Symbol = require("symbol");
symbols = {};

function love.load()
    symbols = PopulateSymbols(5, 5, 5, 5, 5);
end

function love.update(dt)
    -- Symbols update
    for index, value in ipairs(symbols) do
        value.Update(dt);
    end
end

function love.draw()
    -- Symbols rendering
    for index, value in ipairs(symbols) do
        value.Draw();
    end
    -- Ajouter ici les scores de chaque type
end

function love.keypressed(key)
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