-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local Racket = require("racket");
local Ball = require("ball");
leftRacket = Racket.Create();
ball = Ball.Create();

function love.load()
end

function love.update(dt)
    -- Left Racket controls
    if love.keyboard.isDown("z") and leftRacket:CanMove("up") then
        leftRacket:Move("up");
    elseif love.keyboard.isDown("s") and leftRacket:CanMove("down") then
        leftRacket:Move("down");
    end

    -- Ball
    ball:Move();
    if ball:IsCollidingWithRacket(leftRacket) then
        ball.movementSpeedX = -ball.movementSpeedX;
    end
    --if ball:IsCollidingVerticallyWithRacket(leftRacket) then
        --ball.movementSpeedY = -ball.movementSpeedY;
    --end
    if ball:IsCollidingVertically() then
        ball.movementSpeedY = -ball.movementSpeedY;
    end
end

function love.draw()
    love.graphics.rectangle("fill", leftRacket.posX, leftRacket.posY, leftRacket.width, leftRacket.height);
    love.graphics.rectangle("fill", ball.posX, ball.posY, ball.width, ball.height);
end

function love.keypressed(key)
end