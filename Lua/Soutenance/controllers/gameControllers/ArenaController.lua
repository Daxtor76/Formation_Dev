local SpawnPoint = require("constructors/SpawnPoint");
local BGTile = require("constructors/BGTile");
local Collider = require("constructors/Collider");

local ArenaController = {};

function ArenaController:New(imgPath, gridWidth, gridHeight)
    local arenaController = {};
    setmetatable(arenaController, {__index = ArenaController});

    arenaController.image = love.graphics.newImage(imgPath);
    arenaController.imageSize = Vector.New(arenaController.image:getWidth(), arenaController.image:getHeight());
    arenaController.grid = Vector.New(gridWidth, gridHeight);
    arenaController.tiles = arenaController:GenerateTiles();
    arenaController.size = Vector.New(arenaController.grid.x * arenaController.imageSize.x, arenaController.grid.y * arenaController.imageSize.y);
    arenaController.spawnPoints = arenaController:GenerateSpawnPoints(6);

    arenaController.arenaBounds = {};
    arenaController:GenerateArenaBounds();

    table.insert(controllers, arenaController);
    
    return arenaController;
end

function ArenaController:Update()
end

function ArenaController:GenerateArenaBounds()
    self.arenaBounds[1] = Collider:New(Vector.New(0, 0), Vector.New(self.size.x * self.grid.x, 1), "wall");
    self.arenaBounds[2] = Collider:New(Vector.New(0, self.size.y), Vector.New(self.size.x * self.grid.x, 1), "wall");
    self.arenaBounds[3] = Collider:New(Vector.New(0, 0), Vector.New(1, self.size.y * self.grid.y), "wall");
    self.arenaBounds[4] = Collider:New(Vector.New(self.size.x, 0), Vector.New(1, self.size.y * self.grid.y), "wall");
    
    for __, value in ipairs(self.arenaBounds) do
        table.insert(collisionController.colliders, value);
    end
end

function ArenaController:GenerateTiles()
    local tiles = {};

    for i = 0, self.grid.x * self.imageSize.x - 1, self.imageSize.x do
        for y = 0, self.grid.y * self.imageSize.y - 1, self.imageSize.y do
            local tile = BGTile:New(self.image, Vector.New(i + self.imageSize.x * 0.5, y + self.imageSize.y * 0.5), Vector.New(self.imageSize.x, self.imageSize.y), Vector.New(self.imageSize.x * 0.5, self.imageSize.y * 0.5));
            table.insert(tiles, tile);
        end
    end
    
    return tiles;
end

function ArenaController:GenerateSpawnPoints(amountPerTile)
    local spawnPoints = {};

    for __, value in ipairs(self.tiles) do
        for i = 0, amountPerTile - 1 do
            local sp = SpawnPoint:New(Vector.New(value.position.x + love.math.random(-value.size.x * 0.5, value.size.x * 0.5), value.position.y + love.math.random(-value.size.y * 0.5, value.size.y * 0.5)));
            table.insert(spawnPoints, sp);
        end
    end

    return spawnPoints;
end

function ArenaController:DrawBackground()
    for __, value in ipairs(self.tiles) do
        love.graphics.draw(value.img, value.position.x, value.position.y, value.rotation, 1, 1, value.pivot.x, value.pivot.y);
    end
end

function ArenaController:DrawSpawnPoints()
    for __, value in ipairs(self.spawnPoints) do
        love.graphics.setColor(255, 0, 0, 1);
        love.graphics.rectangle("fill", value.position.x, value.position.y, 5, 5);
        love.graphics.setColor(255, 255, 255, 1);
    end
end

return ArenaController;