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
heartLeft.displayOffsetX = 16;
heartLeft.displayOffsetY = 25;
heartLeft.width = heart.img:getWidth();
heartLeft.height = heart.img:getHeight();
heartLeft.timer = 0.4;
heartLeft.currentTimer = heartLeft.timer;
heartLeft.isDisplayed = true;

function isTimerOver(obj, deltaTime)
    obj.currentTimer = obj.currentTimer - deltaTime;
    return obj.currentTimer <= 0;
end
function ResetTimer(obj)
    obj.currentTimer = obj.timer;
end

function love.load()
end

function love.update(dt)
    if dino.life == 0.5 and isTimerOver(heartLeft, dt) then
        heartLeft.isDisplayed = not heartLeft.isDisplayed;
        ResetTimer(heartLeft);
    end
    -- ou 
    --heartLeft.isDisplayed = dino.life == 0.5 and isTimerOver(heartLeft, dt);
    --if heartLeft.isDisplayed then
        --ResetTimer(heartLeft);
    --end
end

function love.draw()
    for i = 0, dino.life - 1 do
        local spawnPos = i%dino.maxLife * heart.width + heart.displayOffset;
        love.graphics.draw(heart.img, spawnPos, 25)
    end

    if dino.life - math.floor(dino.life) > 0 then
        if heartLeft.isDisplayed then
            love.graphics.draw(heartLeft.img, dino.life%math.ceil(dino.maxLife) * heartLeft.width + heartLeft.displayOffsetX, heartLeft.displayOffsetY)
        end
    end
end

function love.keypressed(key, scancode)
    print(scancode); -- Plutôt utiliser le scancode pour que le jeu soit jouable sur tous les claviers de la même façon
    if key == "space" then
        dino:ModifyLife(smallDamages);
    elseif key == "p" then
        dino:ModifyLife(bigDamages);
    end
end