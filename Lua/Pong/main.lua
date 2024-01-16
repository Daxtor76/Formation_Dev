-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local Racket = require("racket");
local Ball = require("ball");

leftRacket = Racket.Create(10, love.graphics.getHeight()/2);
leftRacket.posY = leftRacket.posY - leftRacket.height/2;

rightRacket = Racket.Create(love.graphics.getWidth() - 10, love.graphics.getHeight()/2);
rightRacket.posX = rightRacket.posX - rightRacket.width;
rightRacket.posY = rightRacket.posY - rightRacket.height/2;

ball = Ball.Create();

function love.load()
    sounds = {};
    sounds.collide = love.audio.newSource("Sounds/mur.wav", "static");
    sounds.defeat = love.audio.newSource("Sounds/perdu.wav", "static");
end

function love.update(dt)
    -- General controls
    if love.keyboard.isDown("space") then
        ResetGame();
    end

    -- Left Racket controls
    if love.keyboard.isDown("z") and leftRacket:CanMove("up") then
        leftRacket:Move("up", dt);
    elseif love.keyboard.isDown("s") and leftRacket:CanMove("down") then
        leftRacket:Move("down", dt);
    end

    -- Right Racket controls
    if love.keyboard.isDown("up") and rightRacket:CanMove("up") then
        rightRacket:Move("up", dt);
    elseif love.keyboard.isDown("down") and rightRacket:CanMove("down") then
        rightRacket:Move("down", dt);
    end

    -- Ball
    ball:Move(ball.accel, dt);

    if ball:IsCollidingWithRacket(leftRacket) == 1 then
        ball.movementSpeedX = -ball.movementSpeedX;
        ball:Replace(leftRacket.posX + leftRacket.width, ball.posY);
        ball:IncreaseAccel(ball.accelIncreasePerCollision);
        sounds.collide:play();
    elseif ball:IsCollidingWithRacket(rightRacket) == 3 then
        ball.movementSpeedX = -ball.movementSpeedX;
        ball:Replace(rightRacket.posX - ball.width, ball.posY);
        ball:IncreaseAccel(ball.accelIncreasePerCollision);
        sounds.collide:play();
    end

    if ball:IsCollidingOnWalls() ~= 0 then
        if ball:IsCollidingOnWalls() == 1 then
            print("Right Player wins : +1pt !")
            rightRacket.score = rightRacket.score + 1;
            sounds.defeat:play();
            ball:ResetPos();
            ball:ResetSpeed();
        elseif ball:IsCollidingOnWalls() == 2 then
            ball.movementSpeedY = -ball.movementSpeedY;
            ball:Replace(ball.posX, 0);
            ball:IncreaseAccel(ball.accelIncreasePerCollision);
            sounds.collide:play();
        elseif ball:IsCollidingOnWalls() == 3 then
            print("Left Player wins : +1pt !")
            leftRacket.score = leftRacket.score + 1;
            sounds.defeat:play();
            ball:ResetPos();
            ball:ResetSpeed();
        elseif ball:IsCollidingOnWalls() == 4 then
            ball.movementSpeedY = -ball.movementSpeedY;
            ball:Replace(ball.posX, love.graphics.getHeight() - ball.height);
            ball:IncreaseAccel(ball.accelIncreasePerCollision);
            sounds.collide:play();
        end
    end
end

function love.draw()
    love.graphics.rectangle("fill", leftRacket.posX, leftRacket.posY, leftRacket.width, leftRacket.height);
    love.graphics.rectangle("fill", rightRacket.posX, rightRacket.posY, rightRacket.width, rightRacket.height);
    love.graphics.rectangle("fill", ball.posX, ball.posY, ball.width, ball.height);
    love.graphics.line(love.graphics.getWidth()/2, 0, love.graphics.getWidth()/2, love.graphics.getHeight());
    love.graphics.print(leftRacket.score, love.graphics.getWidth()/2 - 50, 15);
    love.graphics.print(rightRacket.score, love.graphics.getWidth()/2 + 20, 15);
end

function love.keypressed(key)
end

function ResetGame()
    leftRacket:Reset(10, love.graphics.getHeight()/2);
    leftRacket.posY = leftRacket.posY - leftRacket.height/2;

    rightRacket:Reset(love.graphics.getWidth() - 10, love.graphics.getHeight()/2);
    rightRacket.posX = rightRacket.posX - rightRacket.width;
    rightRacket.posY = rightRacket.posY - rightRacket.height/2;

    ball:ResetPos();
    ball:ResetSpeed();
end