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
    bg = {};
    bg.img = love.graphics.newImage("images/background/Texture/TX Tileset Grass.png");
    bg.posX = 0;
    bg.posY = 0;
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
        if hero:IsCollidingOnWalls() == 1 and (hero.movementDirection == 8 or hero.movementDirection == 1 or hero.movementDirection == 2) then
            bg.posX = bg.posX + 500 * dt;
        elseif hero:IsCollidingOnWalls() == 2 and (hero.movementDirection == 2 or hero.movementDirection == 3 or hero.movementDirection == 4) then
            bg.posY = bg.posY + 500 * dt;
        elseif hero:IsCollidingOnWalls() == 3 and (hero.movementDirection == 4 or hero.movementDirection == 5 or hero.movementDirection == 6) then
            bg.posX = bg.posX - 500 * dt;
        elseif hero:IsCollidingOnWalls() == 4 and (hero.movementDirection == 6 or hero.movementDirection == 7 or hero.movementDirection == 8) then
            bg.posY = bg.posY - 500 * dt;
        else
            hero:Move(dt);
        end
    end

    -- Animations
    hero:UpdateAnim(dt, hero.anims[hero.state][math.floor((hero.characterDirection)/2)%4]);
    weapon:UpdateAnim(dt, weapon.anims[weapon.state][0]);
end

function love.draw()

    love.graphics.draw(bg.img, bg.posX, bg.posY, 0, 10, 10);
    -- Render entities layer by layer (0 = the deepest)
    for y = 0, 1 do
        for i=0, #renderList do
            if renderList[i].renderLayer == y then
                renderList[i]:Draw();
            end
        end
    end
end