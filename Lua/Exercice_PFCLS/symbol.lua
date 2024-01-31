local Symbol = {};

function Symbol:New(symbolType, name)
    local tmpSymbol = {};
    setmetatable(tmpSymbol, {__index = Symbol});
    tmpSymbol.type = symbolType;
    tmpSymbol.enemies = tmpSymbol:GetEnemies();
    tmpSymbol.name = symbolType.."";
    tmpSymbol.img = love.graphics.newImage("Images/"..tmpSymbol.type..".png");
    tmpSymbol.width = tmpSymbol.img:getWidth();
    tmpSymbol.height = tmpSymbol.img:getHeight();
    tmpSymbol.posX = love.math.random(tmpSymbol.width*0.5, love.graphics.getWidth() - tmpSymbol.width*0.5);
    tmpSymbol.posY = love.math.random(tmpSymbol.height*0.5, love.graphics.getHeight() - tmpSymbol.width*0.5);
    tmpSymbol.speedX = love.math.random(100, 200);
    tmpSymbol.speedY = love.math.random(100, 200);
    tmpSymbol.direction = love.math.random(0, 7);
    tmpSymbol.pivotX = tmpSymbol.width*0.5;
    tmpSymbol.pivotY = tmpSymbol.height*0.5;

    tmpSymbol.Update = function(dt)
        tmpSymbol:Move(dt);
        if tmpSymbol:IsCollidingOnWalls() == 1 then
            tmpSymbol.speedX = -tmpSymbol.speedX;
            tmpSymbol:Replace(tmpSymbol.width*0.5, tmpSymbol.posY);
        elseif tmpSymbol:IsCollidingOnWalls() == 2 then
            tmpSymbol.speedY = -tmpSymbol.speedY;
            tmpSymbol:Replace(tmpSymbol.posX, tmpSymbol.height*0.5);
        elseif tmpSymbol:IsCollidingOnWalls() == 3 then
            tmpSymbol.speedX = -tmpSymbol.speedX;
            tmpSymbol:Replace(screenWidth - tmpSymbol.width*0.5, tmpSymbol.posY);
        elseif tmpSymbol:IsCollidingOnWalls() == 4 then
            tmpSymbol.speedY = -tmpSymbol.speedY;
            tmpSymbol:Replace(tmpSymbol.posX, screenHeight - tmpSymbol.height*0.5);
        end

        for key, value in pairs(symbols) do
            if tmpSymbol ~= value then
                if tmpSymbol:IsSymbolColliding(value) then
                    if tmpSymbol.enemies[0] == value.type or tmpSymbol.enemies[1] == value.type then
                        symbolsCount[value.type] = symbolsCount[value.type] - 1;
                        table.remove(symbols, key);
                    end
                end
            end
        end
    end

    tmpSymbol.Draw = function()
        love.graphics.draw(tmpSymbol.img, 
            tmpSymbol.posX, 
            tmpSymbol.posY, 
            0, 
            1, 
            1,
            tmpSymbol.pivotX,
            tmpSymbol.pivotY);
    end

    --print("Create instance of Symbol of type "..tmpSymbol.type);

    return tmpSymbol;
end

function Symbol:GetEnemies()
    local enemies = {};

    if self.type == "Lizard" then
        enemies[0] = "Spock";
        enemies[1] = "Paper";
    elseif self.type == "Paper" then
        enemies[0] = "Rock";
        enemies[1] = "Spock";
    elseif self.type == "Rock" then
        enemies[0] = "Lizard";
        enemies[1] = "Scissors";
    elseif self.type == "Scissors" then
        enemies[0] = "Paper";
        enemies[1] = "Lizard";
    elseif self.type == "Spock" then
        enemies[0] = "Scissors";
        enemies[1] = "Rock";
    end

    return enemies;
end

function Symbol:IsSymbolColliding(other)
    local distance = math.sqrt((self.posX - other.posX)^2 + (self.posY - other.posY)^2)
    return distance < (self.width*0.5 + other.width*0.5)
end

function Symbol:Replace(newPosX, newPosY)
    self.posX = newPosX;
    self.posY = newPosY;
end

function Symbol:IsCollidingOnWalls()
    local downFacePosY = self.posY + self.height*0.5;
    local upperFacePosY = self.posY - self.height*0.5;
    local leftFacePosX = self.posX - self.width*0.5;
    local rightFacePosX = self.posX + self.width*0.5;

    if leftFacePosX < 0 then
        return 1;
    elseif upperFacePosY < 0 then
        return 2;
    elseif rightFacePosX > love.graphics.getWidth() then
        return 3;
    elseif downFacePosY > love.graphics.getHeight() then
        return 4;
    else
        return 0;
    end
end

function Symbol:Move(deltaTime)
    if self.direction == 0 then
        -- left
        self.posX = self.posX%screenWidth - self.speedX * deltaTime;
    elseif self.direction == 1 then
        -- up left
        self.posX = self.posX%screenWidth - self.speedX * deltaTime;
        self.posY = self.posY%screenHeight - self.speedY * deltaTime;
    elseif self.direction == 2 then
        -- up
        self.posY = self.posY%screenHeight - self.speedY * deltaTime;
    elseif self.direction == 3 then
        -- up right
        self.posX = self.posX%screenWidth + self.speedX * deltaTime;
        self.posY = self.posY%screenHeight - self.speedY * deltaTime;
    elseif self.direction == 4 then
        -- right
        self.posX = self.posX%screenWidth + self.speedX * deltaTime;
    elseif self.direction == 5 then
        -- down right
        self.posX = self.posX%screenWidth + self.speedX * deltaTime;
        self.posY = self.posY%screenHeight + self.speedY * deltaTime;
    elseif self.direction == 6 then
        -- down
        self.posY = self.posY%screenHeight + self.speedY * deltaTime;
    elseif self.direction == 7 then
        -- down left
        self.posX = self.posX%screenWidth - self.speedX * deltaTime;
        self.posY = self.posY%screenHeight + self.speedY * deltaTime;
    end
end

return Symbol;