-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local Racket = require("racket");
leftRacket = Racket.Create();

function love.load()
end

function love.update(dt)
    if love.keyboard.isDown("s") then
        leftRacket.posY = leftRacket.posY + leftRacket.movementSpeed;
    elseif love.keyboard.isDown("z") then
        leftRacket.posY = leftRacket.posY - leftRacket.movementSpeed;
    end
end

function love.draw()
    love.graphics.rectangle("fill", leftRacket.posX, leftRacket.posY, leftRacket.width, leftRacket.height);
end

function love.keypressed(key)
end