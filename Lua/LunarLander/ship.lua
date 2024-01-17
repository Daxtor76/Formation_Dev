local Ship = {};

local ship_mt = {__index = Ship};

function Ship.Create(posX, posY)

    print("Création d'une instance de Racket");

    local tmpShip = {};
    tmpShip.ship = love.graphics.newImage("Images/ship.png");
    tmpShip.engine = love.graphics.newImage("Images/engine.png");
    tmpShip.width = tmpShip.ship:getWidth();
    tmpShip.height = tmpShip.ship:getHeight();
    tmpShip.posX = posX;
    tmpShip.posY = posY;
    tmpShip.velX = 0;
    tmpShip.velY = 0;
    tmpShip.rotation = -90;
    tmpShip.rotationSpeed = 150;
    tmpShip.enginePower = 2;
    tmpShip.isEngineOn = false;
    return setmetatable(tmpShip, ship_mt);
end

function Ship:SetRotation(value, dt)
    self.rotation = self.rotation + value * dt;
end

function Ship:EnableEngine(value, dt)
    self.isEngineOn = true;
    self.velX = (self.velX) + math.cos(math.rad(self.rotation)) * dt;
    self.velY = (self.velY) + math.sin(math.rad(self.rotation)) * value * dt;
end

function Ship:DisableEngine()
    self.isEngineOn = false;
end

return Ship;