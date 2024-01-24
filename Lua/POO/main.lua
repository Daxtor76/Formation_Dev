-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

Entity = require("entity");
Ship = require("ship");

local myEntity = Entity:New(10, 10);
local myEntity2 = Ship:New(200, 200);

function love.load()
end

function love.update(dt)
    Entity:Update();
end

function love.draw()
end

function love.keypressed(key)
end