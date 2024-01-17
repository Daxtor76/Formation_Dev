-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local screenWidth = love.graphics.getWidth();
local screenHeight = love.graphics.getHeight();

local gravityEffect = 1;

local Ship = require("ship");
ship = Ship.Create(screenWidth / 2, screenHeight / 2);

function love.load()
end

function love.update(dt)
    -- Gravity
    ApplyGravity(ship, dt);

    -- Ship
    -- Apply velocity on ship pos
    ship.posX = ship.posX + ship.velX;
    ship.posY = ship.posY + ship.velY;

    -- Ship controls
    -- Engine
    if love.keyboard.isDown("z") then
        ship:EnableEngine(ship.enginePower, dt);
    else
        ship:DisableEngine();
    end

    -- Rotation
    if love.keyboard.isDown("d") then
        ship:SetRotation(ship.rotationSpeed, dt);
    elseif love.keyboard.isDown("q") then
        ship:SetRotation(-ship.rotationSpeed, dt);
    end
end

function love.draw()
    -- Moon rendering
    love.graphics.circle("fill", screenWidth/2, screenHeight * 2.1, screenWidth, 100);

    -- Ship rendering
    love.graphics.draw(ship.ship, ship.posX + ship.width/2, ship.posY + ship.height/2, math.rad(ship.rotation), 1, 1, ship.width/2, ship.height/2);
    if ship.isEngineOn then
        love.graphics.draw(ship.engine, ship.posX + ship.width/2, ship.posY + ship.height/2, math.rad(ship.rotation), 1, 1, ship.engine:getWidth()/2, ship.engine:getHeight()/2);
    end
end

function love.keypressed(key)
end

function ApplyGravity(obj, dt)
    obj.velY = obj.velY + gravityEffect * dt;
end