local Cyclope = require("entities/enemies/Cyclope");
local Sorceress = require("entities/enemies/Sorceress");

local Wave = {};

function Wave:NewWave(frequency, duration, cyclopes, sorceress, enemiesAmount, speedMultiplier, attackSpeedMultiplier, damagesMultiplier, lifeMultiplier)
    local wave = {};
    setmetatable(wave, {__index = Wave});

    wave.frequency = frequency;
    wave.duration = duration;
    wave.timer = wave.frequency;
    wave.enemiesAmount = enemiesAmount;

    wave.canSpawnCyclopes = cyclopes;
    wave.canSpawnSorceress = sorceress;

    wave.speedMultiplier = speedMultiplier;
    wave.attackSpeedMultiplier = attackSpeedMultiplier;
    wave.damagesMultiplier = damagesMultiplier;
    wave.lifeMultiplier = lifeMultiplier;

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
    --print("new sub wave");
    for i = 0, enemiesAmount - 1 do
        local randEnemyType = 0;
        if self.canSpawnCyclopes and self.canSpawnSorceress then
            randEnemyType = love.math.random(0, 1);
        elseif self.canSpawnCyclopes then
            randEnemyType = 0;
        else
            randEnemyType = 1;
        end

        local randSpawnPoint = love.math.random(1, #arena.spawnPoints);

        enemiesCount = enemiesCount + 1;
        if randEnemyType == 0 then
            Cyclope:New(
                arena.spawnPoints[randSpawnPoint].position.x, 
                arena.spawnPoints[randSpawnPoint].position.y,
                80 * self.speedMultiplier,
                1.2 * self.attackSpeedMultiplier,
                math.ceil(1 * self.damagesMultiplier),
                math.ceil(3 * self.lifeMultiplier)
            );
        else
            Sorceress:New(
                arena.spawnPoints[randSpawnPoint].position.x, 
                arena.spawnPoints[randSpawnPoint].position.y,
                75 * self.speedMultiplier,
                2.3 * self.attackSpeedMultiplier,
                math.ceil(2 * self.damagesMultiplier),
                math.ceil(2 * self.lifeMultiplier)
            );
        end
    end
end

return Wave;