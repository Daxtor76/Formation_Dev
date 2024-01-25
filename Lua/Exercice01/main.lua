-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

screenWidth = love.graphics.getWidth();
screenHeight = love.graphics.getHeight();

Ship = require("ship");
ships = {};

function love.load()
    ships = PopulateShips(10);
end

function love.update(dt)
    -- Ship movement
    for i=1, #ships do
        ships[i]:Move(dt);
        if ships[i]:IsTimeToChangeDirection(dt) then
            ships[i].direction = love.math.random(1, 8);
            ships[i].rotation = ConvertAngle(ships[i].direction * 45);
        end
    end
end

function love.draw()
    -- Ship rendering
    for i=1, #ships do
        love.graphics.draw(ships[i].ship, ships[i].posX + ships[i].width/2, ships[i].posY + ships[i].height/2, ships[i].rotation, 1, 1, ships[i].width/2, ships[i].height/2);
    end
end

function love.keypressed(key)
end

function PopulateShips(amount)
    local ships = {}
    for i=1, amount do
        ship = Ship:New(love.math.random(0, screenWidth), love.math.random(0, screenHeight));
        ships[i] = ship;
    end
    return ships;
end