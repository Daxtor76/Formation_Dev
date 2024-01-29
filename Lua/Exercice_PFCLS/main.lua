-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

screenWidth = love.graphics.getWidth();
screenHeight = love.graphics.getHeight();

local Symbol = require("symbol");
local symbols = {};

function love.load()
    symbols = PopulateSymbols(5, 5, 5, 5, 5);
end

function love.update(dt)
    -- Symbols movement
    --for i=1, #symbols do
        --symbols[i]:Move(dt);

        for key, value in pairs(symbols) do -- Récupère chaque élément d'une table et sa valeur
            --print(key.." - "..value);
        end

        for index, value in ipairs(symbols) do -- Récupère un élément d'une table pour tous les éléments d'une table
            value.Update(dt);
        end
    --end
end

function love.draw()
    -- Symbols rendering
    for i=1, #symbols do
        symbols[i].Draw();
    end
end

function love.keypressed(key)
end

function PopulateSymbols(lizardsAmount, papersAmount, rocksAmount, scissorsAmount, spocksAmount)
    local symbols = {}
    local total = lizardsAmount + papersAmount + rocksAmount + scissorsAmount + spocksAmount;
    for i=0, total do
        local symbol = nil;
        if i < lizardsAmount then
            symbol = Symbol:New("Lizard");
        elseif i < lizardsAmount + papersAmount then
            symbol = Symbol:New("Paper");
        elseif i < lizardsAmount + papersAmount + rocksAmount then
            symbol = Symbol:New("Rock");
        elseif i < lizardsAmount + papersAmount + rocksAmount + scissorsAmount then
            symbol = Symbol:New("Scissors");
        elseif i < total then
            symbol = Symbol:New("Spock");
        end
        symbols[i] = symbol;
    end
    return symbols;
end