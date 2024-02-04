-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("utils");
require("entities/_entity");
local Hero = require("entities/hero");
local hero = Hero:New(screenWidth*0.5, screenHeight*0.5);

function love.load()
end

function love.update(dt)
    angle = math.atan2(hero.posY - GetMousePos()["y"], hero.posX - GetMousePos()["x"])
    x = GetDistance(GetMousePos()["x"], GetMousePos()["y"], hero.posX, hero.posY) * math.cos(angle);
    y = GetDistance(GetMousePos()["x"], GetMousePos()["y"], hero.posX, hero.posY) * math.sin(angle);
    --print(x.."/"..y);
    hero.direction = math.floor(((math.deg(angle)+360)%360)/45) + 1;
    -- = math.abs(math.floor(test)*2)
    hero:UpdateAnim(dt);
    if hero.state == 1 then
        hero:Move(dt);
    end
end

function love.draw()
    hero:Draw();
    --love.graphics.line(hero.posX, hero.posY, GetMousePos()["x"], GetMousePos()["y"]);
end

function love.keypressed(key)
    if (love.keyboard.isDown(love.keyboard.getScancodeFromKey("a")) or 
        love.keyboard.isDown(love.keyboard.getScancodeFromKey("w")) or 
        love.keyboard.isDown("d") or 
        love.keyboard.isDown("s")) and hero.state ~= 1 then
            hero:ChangeState("run");
            hero:UpdateDirectionByKeysPressed();
    end
end

function love.keyreleased(key)
end
