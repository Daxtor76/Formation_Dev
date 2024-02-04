-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("utils");
require("entities/_entity");
local Hero = require("entities/hero");
local Weapon = require("entities/weapon");
hero = Hero:New(screenWidth*0.5, screenHeight*0.5);
weapon = Weapon:New(hero.posX, hero.posY);

renderList = {};
renderList[0] = hero;
renderList[1] = weapon;

function love.load()
end

function love.update(dt)
    -- Weapon Controls
    weapon:Replace(hero.posX, hero.posY);

    -- Hero Controls
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

    -- Hero Movement
    if hero.state == 1 then
        hero:Move(dt);
    end

    -- Animations
    hero:UpdateAnim(dt, hero.anims[hero.state][math.floor((hero.characterDirection)/2)%4]);
    weapon:UpdateAnim(dt, weapon.anims[weapon.state][0]);
end

function love.draw()
    -- Render entities layer by layer (0 = the deepest)
    for y = 0, 1 do
        for i=0, #renderList do
            if renderList[i].renderLayer == y then
                renderList[i]:Draw();
            end
        end
    end
end
