-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("entities/entity");
local Ship = require("entities/ship");
local ship = Ship:New();

function love.load()
    ship:Update();
end

function love.update(dt)
end

function love.draw()
end

function love.keypressed(key)
end
