-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

gameState = "Preparation";

local Racket = require("racket");
local Ball = require("ball");
local Brick = require("brick");

racket = Racket.Create(love.graphics.getWidth()/2, love.graphics.getHeight());
racket.posX = racket.posX - racket.width/2;
racket.posY = racket.posY - racket.height*3;

ball = Ball.Create(racket);

bricks = {};

function PopulateBricks(lines, columns)
    local bricks = {}

    for i=1, lines do
        for y=1, columns do
            local brick = Brick.Create();
            brick.posX = y*brick.width + y*brick.margin;
            brick.posY = i*brick.height + i*brick.margin;
            table.insert(bricks, brick);
            print("Pos x : "..brick.posX.." / Pos y : "..brick.posY);
        end
    end
    
    print(#bricks.." bricks added");

    return bricks;
end

function love.load()
    sounds = {};
    sounds.collide = love.audio.newSource("Sounds/mur.wav", "static");
    sounds.defeat = love.audio.newSource("Sounds/perdu.wav", "static");
    bricks = PopulateBricks(6, 10);
end

function love.update(dt)
    -- Racket controls
    if love.keyboard.isDown("q") and racket:CanMove("left") then 
        racket:Move("left", dt);
    elseif love.keyboard.isDown("d")and racket:CanMove("right") then
        racket:Move("right", dt);
    end

    -- Ball
        -- Movement
    if gameState == "Preparation" then
        ball:FollowRacket(racket)
    else
        ball:Move(ball.accel, dt);
    end

        -- Collisions
    if ball:IsCollidingWithRacket(racket) then
        local collPos = ball:GetRacketCollisionLocation(racket)
        if collPos >= 0 and collPos < 33 then
            ball.movementSpeedX = ball.baseMovementSpeed;
            if Sign(ball.movementSpeedX) == 1 then
                ball.movementSpeedX = -ball.movementSpeedX;
            end
        elseif collPos >= 33 and collPos < 66 then
            ball.movementSpeedX = 0;
        else
            ball.movementSpeedX = ball.baseMovementSpeed;
            if Sign(ball.movementSpeedX) == -1 then
                ball.movementSpeedX = -ball.movementSpeedX;
            end
        end
        ball.movementSpeedY = -ball.movementSpeedY;
        ball:Replace(ball.posX, racket.posY - ball.height);
        sounds.collide:play();
    end

    if ball:IsCollidingOnWalls() ~= 0 then
        if ball:IsCollidingOnWalls() == 1 then
            ball.movementSpeedX = -ball.movementSpeedX;
            ball:Replace(0, ball.posY);
            sounds.collide:play();
        elseif ball:IsCollidingOnWalls() == 2 then
            ball.movementSpeedY = -ball.movementSpeedY;
            ball:Replace(ball.posX, 0);
            sounds.collide:play();
        elseif ball:IsCollidingOnWalls() == 3 then
            ball.movementSpeedX = -ball.movementSpeedX;
            ball:Replace(love.graphics.getWidth() - ball.width, ball.posY);
            sounds.collide:play();
        elseif ball:IsCollidingOnWalls() == 4 then
            -- AJOUTER DEFAITE ICI
            ball.movementSpeedY = -ball.movementSpeedY;
            ball:Replace(ball.posX, love.graphics.getHeight() - ball.height);
            sounds.collide:play();
        end
    end
end

function love.draw()
    -- WHITE THINGS
    love.graphics.setColor(255, 255, 255);

    -- Racket rendering
    love.graphics.rectangle("fill", racket.posX, racket.posY, racket.width, racket.height);

    -- Ball rendering
    if gameState == "Preparation" then
        love.graphics.rectangle("fill", racket.posX + racket.width/2 - ball.width/2, racket.posY - ball.height, ball.width, ball.height);
    else
        love.graphics.rectangle("fill", ball.posX, ball.posY, ball.width, ball.height);
    end

    -- Bricks rendering
    for i=1, #bricks do
        love.graphics.rectangle("fill", bricks[i].posX, bricks[i].posY, bricks[i].width, bricks[i].height);
    end
end

function love.keypressed(key)
    -- General controls
    if key == "space" and gameState ~= "Playing" then
        LaunchBall();
    end
end

function LaunchBall()
    gameState = "Playing";
    ball:ApplyDirection(racket:ScreenPlacement());
end

function ResetGame()
end

function Sign(n)
	return n < 0 and -1 or n > 0 and 1 or 0
end