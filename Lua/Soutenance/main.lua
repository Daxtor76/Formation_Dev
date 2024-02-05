-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- TO DO: Charger tous les require dans main car si existe à plusieurs endroits, ne sera chargé qu'une fois tout pareil
require("utils");
require("entities/_entity");
local Hero = require("entities/hero");
local Weapon = require("entities/weapon");

hero = Hero:New(screenWidth*0.5, screenHeight*0.5);
weapon = Weapon:New(hero.posX, hero.posY);

local scrollSpeed = 350;
local scrollDist = 150;

local renderList = {};
renderList[0] = hero;
renderList[1] = weapon;

function love.load()
    bg = {};
    bg.img = love.graphics.newImage("images/background/Texture/TX Tileset Grass.png");
    bg.posX = 0;
    bg.posY = 0;
end

-- TO DO: Ajouter un ScenesController.lua qui va gérer les états du jeu
-- une table qui contient toutes les scènes (états du jeu)
-- qui contient la scène courante
-- une fonction pour changer de scène
-- une fonction pour charger les dépendances nécessaires
-- une fonction updateCurrentScene(dt)
-- une fonction drawCurrentScene()

function love.update(dt)
    -- Weapon Controls
    weapon:Replace(hero.posX, hero.posY);

    -- Hero Controls
    hero:UpdateCharacterDirectionByMousePos();
    
    -- Hero states machine
    if (love.keyboard.isDown(love.keyboard.getScancodeFromKey("a")) or 
        love.keyboard.isDown(love.keyboard.getScancodeFromKey("w")) or 
        love.keyboard.isDown("d") or 
        love.keyboard.isDown("s")) then 
        hero:UpdateMovementDirectionByKeysPressed(dt);
        if hero.state ~= 1 then
            hero:ChangeState("run");
        end
    else
        if hero.state ~= 0 then
            hero:ChangeState("idle");
        end
    end

    -- Hero Movement & Collision with camera bounds
    if hero.state == 1 then
        hero:Move(dt);
        if GetDistance(hero.posX, hero.posY, screenWidth*0.5, screenHeight*0.5) > scrollDist then
            -- Move background so that the hero moves in the world
            bg.posX = bg.posX - scrollSpeed * dt * math.cos(math.atan2(hero.posY - screenHeight*0.5, hero.posX - screenWidth*0.5));
            bg.posY = bg.posY - scrollSpeed * dt * math.sin(math.atan2(hero.posY - screenHeight*0.5, hero.posX - screenWidth*0.5));
            
            -- Replace hero so that he cannot go outside of the camera bounds
            local newHeroPosX = screenWidth*0.5 + (scrollDist) * math.cos(math.atan2(hero.posY - screenHeight*0.5, hero.posX - screenWidth*0.5));
            local newHeroPosY = screenHeight*0.5 + (scrollDist) * math.sin(math.atan2(hero.posY - screenHeight*0.5, hero.posX - screenWidth*0.5));
            hero:Replace(newHeroPosX, newHeroPosY);
        end
    end

    -- Animations
    hero:UpdateAnim(dt, hero.anims[hero.state][math.floor((hero.characterDirection)/2)%4]);
    weapon:UpdateAnim(dt, weapon.anims[weapon.state][0]);
end

function love.draw()
    -- BG
    love.graphics.draw(bg.img, bg.posX, bg.posY, 0, 10, 10);

    -- Render entities layer by layer (0 = the deepest)
    for y = 0, 1 do
        for i=0, #renderList do
            if renderList[i].renderLayer == y then
                renderList[i]:Draw();
            end
        end
    end

    -- Crosshair
    ReplaceMouseCrosshair(hero.crosshair);
end
