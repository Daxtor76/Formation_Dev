-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("entities/_entity");
local Hero = require("entities/hero");
local hero = Hero:New(screenWidth*0.5, screenHeight*0.5);

function love.load()
end

function love.update(dt)
    hero:UpdateDirectionByKeysPressed();
    hero:UpdateAnim(dt);
    if hero.state == 1 then
        hero:Move(dt);
    end
end

function love.draw()
    hero:Draw();
end

function love.keypressed(key)
end
