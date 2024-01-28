-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

screenWidth = love.graphics.getWidth();
screenHeight = love.graphics.getHeight();

Dino = require("dino");
dino = Dino:New();

smallDamages = 0.5;
bigDamages = 1;

heart = {};
heart.img = love.graphics.newImage("Images/heart_full.png");
heart.displayOffset = 25;
heart.width = heart.img:getWidth();
heart.height = heart.img:getHeight();

heartLeft = {};
heartLeft.img = love.graphics.newImage("Images/heart_left.png");
heartLeft.displayOffset = 25;
heartLeft.width = heart.img:getWidth();
heartLeft.height = heart.img:getHeight();

function love.load()
end

function love.update(dt)
end

function love.draw()
    for i = 0, dino.life - 1 do
        local spawnPos = i%dino.maxLife * heart.width + heart.displayOffset;
        love.graphics.draw(heart.img, spawnPos, 25)
    end

    if dino.life - math.floor(dino.life) > 0 then
        love.graphics.draw(heartLeft.img, dino.life%math.ceil(dino.maxLife) * heartLeft.width + heartLeft.displayOffset * 0.65, heartLeft.displayOffset)
    end
end

function love.keypressed(key)
    if key == "space" then
        dino:ModifyLife(smallDamages);
    elseif key == "p" then
        dino:ModifyLife(bigDamages);
    end
end