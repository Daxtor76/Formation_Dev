local Cyclope = require("entities/enemies/Cyclope");
local Sorceress = require("entities/enemies/Sorceress");

local SubWave = {};

function Wave:NewWave(frequency, duration, enemiesAmount)
    local wave = {};
    wave.frequency = frequency;
    wave.duration = duration;
    wave.timer = wave.frequency;
    wave.enemiesAmount = enemiesAmount;
    
    wave.InitSubWave = function()
        print("new sub wave");
        wave.timer = wave.frequency;
        local subwave = self:NewSubWave();
        subwave.SpawnEnemies(wave.enemiesAmount);
    end

    wave.UpdateSubWave = function(dt)
        wave.timer = wave.timer - dt;
        if wave.timer <= 0 then
            wave.InitSubWave();
        end
    end

    return wave;
end

function SubWave:NewSubWave()
    local subWave = {};
    subWave.SpawnEnemies = function(enemiesAmount)
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

    return subWave;
end

return SubWave;