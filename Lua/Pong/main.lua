-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local Racket = require("racket");
local Racket2 = require("racket");
local Ball = require("ball");
leftRacket = Racket.Create(10, 10);
rightRacket = Racket2.Create(love.graphics.getWidth() - 10, love.graphics.getHeight()/2);
rightRacket.posX = rightRacket.posX - rightRacket.width;
rightRacket.posY = rightRacket.posY - rightRacket.height/2;
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

    -- Right Racket controls
    if love.keyboard.isDown("up") and rightRacket:CanMove("up") then
        rightRacket:Move("up");
    elseif love.keyboard.isDown("down") and rightRacket:CanMove("down") then
        rightRacket:Move("down");
    end

    -- Ball
    ball:Move();
    if ball:IsCollidingWithRacket(leftRacket) == 0 or ball:IsCollidingWithRacket(rightRacket) == 0 then
        print("Horizontal side of the ball is colliding");
        ball.movementSpeedX = -ball.movementSpeedX;
    elseif ball:IsCollidingWithRacket(leftRacket) == 1 or ball:IsCollidingWithRacket(rightRacket) == 1 then
        print("Vertical side of the ball is colliding");
        ball.movementSpeedY = -ball.movementSpeedY;
    end
    if ball:IsCollidingWithUpAndDownWalls() then
        ball.movementSpeedY = -ball.movementSpeedY;
    end
end

function love.draw()
    love.graphics.rectangle("fill", leftRacket.posX, leftRacket.posY, leftRacket.width, leftRacket.height);
    love.graphics.rectangle("fill", rightRacket.posX, rightRacket.posY, rightRacket.width, rightRacket.height);
    love.graphics.rectangle("fill", ball.posX, ball.posY, ball.width, ball.height);
end

function love.keypressed(key)
end