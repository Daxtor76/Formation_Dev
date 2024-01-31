-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("game");

screenWidth = love.graphics.getWidth();
screenHeight = love.graphics.getHeight();

local game = NewGameState();

function love.load()
    game.Load()
end

function love.update(dt)
    game.Update(dt);
end

function love.draw()
    game.Draw();
end

function love.keypressed(key)
end