-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("utils");
require("entities/_entity");
local Hero = require("entities/hero");
--local Weapon = require("entities/weapon");
local hero = Hero:New(screenWidth*0.5, screenHeight*0.5);
--local weapon = Weapon:New(hero.posX, hero.posY);

function love.load()
end

function love.update(dt)
    -- Some maths / Clean it later
    --x = GetDistance(GetMousePos()["x"], GetMousePos()["y"], hero.posX, hero.posY) * math.cos(angle);
    --y = GetDistance(GetMousePos()["x"], GetMousePos()["y"], hero.posX, hero.posY) * math.sin(angle);

    hero:UpdateCharacterDirectionByMousePos();
    
    if (love.keyboard.isDown(love.keyboard.getScancodeFromKey("a")) or 
        love.keyboard.isDown(love.keyboard.getScancodeFromKey("w")) or 
        love.keyboard.isDown("d") or 
        love.keyboard.isDown("s")) then 
        hero:UpdateMovementDirectionByKeysPressed();
        if hero.state ~= 1 then
            hero:ChangeState("run");
        end
    else
        if hero.state ~= 0 then
            hero:ChangeState("idle");
        end
    end

    hero:UpdateAnim(dt, hero.anims[hero.state][math.floor((hero.characterDirection)/2)%4]);
    --weapon:UpdateAnim(dt, weapon.anims[weapon.state][0]);
    if hero.state == 1 then
        hero:Move(dt);
    end
end

function love.draw()
    hero:Draw();
    --weapon:Draw();
    --love.graphics.line(hero.posX, hero.posY, GetMousePos()["x"], GetMousePos()["y"]);
end

function love.keypressed(key)
end

function love.keyreleased(key)
end
