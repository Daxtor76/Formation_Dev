-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local screenWidth = love.graphics.getWidth();
local screenHeight = love.graphics.getHeight();

local gravityEffect = 1;

local moon = {};
moon.posX = screenWidth/2;
moon.posY = screenHeight * 2.1;
moon.radius = screenWidth;

local Ship = require("ship");
ship = Ship.Create(screenWidth / 2, screenHeight / 2);

function love.load()
end

function love.update(dt)
    local distanceShipMoon = GetDistance(ship.posX, ship.posY, moon.posX, moon.posY) - moon.radius;
    local distanceNoseMoon = GetDistance(ship.posX + ship.width/2, ship.posY, moon.posX, moon.posY) - moon.radius;
    --print(distanceShipMoon);
    --print(distanceNoseMoon);

    -- Ship
        -- Apply velocity on ship pos
    ship.posX = ship.posX + ship.velX;
    ship.posY = ship.posY + ship.velY;

    -- Ship controls & collisions
        -- Engine
    if love.keyboard.isDown("z") then
        ship:EnableEngine(ship.enginePower, dt);
    else
        ship:DisableEngine();
    end

    -- Collisions
    if  distanceShipMoon < 14 and love.keyboard.isDown("z") == false then
        ship.velX = 0;
        ship.velY = 0;

        -- Check defeat
        if ship.rotation < -120 or ship.rotation > -60 then
            ResetGame();
        end
    else
        -- Gravity
        ApplyGravity(ship, dt);
    end

        -- Rotation
    if distanceShipMoon >= 14 and love.keyboard.isDown("d") then
        ship:SetRotation(ship.rotationSpeed, dt);
    elseif distanceShipMoon >= 14 and love.keyboard.isDown("q") then
        ship:SetRotation(-ship.rotationSpeed, dt);
    end
end

function love.draw()
    -- Moon rendering
    love.graphics.circle("fill", moon.posX, moon.posY, moon.radius, 100);

    -- Ship rendering
    love.graphics.draw(ship.ship, ship.posX + ship.width/2, ship.posY + ship.height/2, math.rad(ship.rotation), 1, 1, ship.width/2, ship.height/2);
    if ship.isEngineOn then
        love.graphics.draw(ship.engine, ship.posX + ship.width/2, ship.posY + ship.height/2, math.rad(ship.rotation), 1, 1, ship.engine:getWidth()/2, ship.engine:getHeight()/2);
    end
end

function love.keypressed(key)
    if key == "space" then
        ResetGame();
    end
end

function ApplyGravity(obj, dt)
    obj.velY = obj.velY + gravityEffect * dt;
end

function GetDistance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2);
end

function ResetGame()
    ship.posX = screenWidth / 2;
    ship.posY = screenHeight / 2;
    ship.velX = 0;
    ship.velY = 0;
    ship.rotation = -90;
    ship.isEngineOn = false;
end