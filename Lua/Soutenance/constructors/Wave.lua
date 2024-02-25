local Cyclope = require("entities/enemies/Cyclope");
local Sorceress = require("entities/enemies/Sorceress");

local Wave = {};

function Wave:NewWave(frequency, duration, enemiesAmount)
    local wave = {};
    setmetatable(wave, {__index = Wave});

    wave.frequency = frequency;
    wave.duration = duration;
    wave.timer = wave.frequency;
    wave.enemiesAmount = enemiesAmount;

    return wave;
end

function Wave:UpdateSubWave(dt)
    self.timer = self.timer - dt;
    if self.timer <= 0 then
        self.timer = self.frequency;
        self:SpawnEnemies(self.enemiesAmount);
    end
end

function Wave:SpawnEnemies(enemiesAmount)
    print("new sub wave");
    for i = 0, enemiesAmount - 1 do
        local randEnemyType = love.math.random(0, 1);
        local randSpawnPoint = love.math.random(1, #arena.spawnPoints);
        enemiesCount = enemiesCount + 1;
        if randEnemyType == 0 then
            Cyclope:New(arena.spawnPoints[randSpawnPoint].position.x, arena.spawnPoints[randSpawnPoint].position.y);
        else
            Sorceress:New(arena.spawnPoints[randSpawnPoint].position.x, arena.spawnPoints[randSpawnPoint].position.y);
        end
    end
end

return Wave;