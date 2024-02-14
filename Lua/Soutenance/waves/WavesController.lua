-- Force des waves basées sur le lvl du hero
-- Vague(1, 2, 3...) subdivisée en minivague (1.1, 1.2, 1.3...)
-- Nombre donné dans une wave => en mob par seconde
-- Déterminer un temps de spawn (durée au bout de laquelle la vague 1.2 pop)

-- Placer des spawn points sur la carte
local Cyclope = require("entities/Cyclope");
local Sorceress = require("entities/Sorceress");

local wavesController = {};
wavesController.waves = {};
wavesController.currentWave = 0;
wavesController.currentSubWave = 0;

wavesController.Begin = function()
    wavesController.waves[0] = wavesController.NewWave(0);
    wavesController.waves[0].subWaves[0].SpawnEnemies();
end

wavesController.NewWave = function(frequency)
    local wave = {};
    wave.subWaves = {};
    wave.spawnFrequency = frequency;

    wave.subWaves[0] = wavesController.NewSubWave(15);

    return wave;
end

wavesController.NewSubWave = function(enemiesAmount)
    local subWave = {};
    subWave.enemiesAmount = enemiesAmount;
    subWave.SpawnEnemies = function()
        for i = 0, enemiesAmount - 1 do
            local randEnemyType = love.math.random(0, 1);
            local randSpawnPoint = love.math.random(1, #bg.spawnPoints);
            if randEnemyType == 0 then
                Cyclope:New(bg.spawnPoints[randSpawnPoint].position.x, bg.spawnPoints[randSpawnPoint].position.y);
            else
                Sorceress:New(bg.spawnPoints[randSpawnPoint].position.x, bg.spawnPoints[randSpawnPoint].position.y);
            end
        end
    end

    return subWave;
end

return wavesController;