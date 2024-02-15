-- Force des waves basées sur le lvl du hero
-- Vague(1, 2, 3...) subdivisée en minivague (1.1, 1.2, 1.3...)
-- Nombre donné dans une wave => en mob par seconde
-- Déterminer un temps de spawn (durée au bout de laquelle la vague 1.2 pop)

-- Placer des spawn points sur la carte
local Cyclope = require("entities/Cyclope");
local Sorceress = require("entities/Sorceress");

local wavesController = {};
wavesController.waves = {};
wavesController.waveCounter = 0;
wavesController.currentWave = nil;
wavesController.timer = 0;

wavesController.Init = function()
    wavesController.waves = wavesController.PopulateWaves();
    wavesController.currentWave = wavesController.waves[wavesController.waveCounter];
    wavesController.timer = wavesController.currentWave.duration;
end

wavesController.UpdateWave = function(dt)
    -- toutes les X secondes, spawn les enemy de la currentsubwave puis passer à la suivante
    wavesController.timer = wavesController.timer - dt;
    if wavesController.timer%wavesController.currentWave.frequency <= 0.005 then
        -- Spawn enemies here
    end

    if wavesController.timer <= 0 then
        wavesController.waveCounter = wavesController.waveCounter + 1;
        wavesController.currentWave = wavesController.waves[wavesController.waveCounter];
    end
end

wavesController.NewWave = function(frequency, duration)
    local wave = {};
    wave.subWaves = {};
    wave.subWaves[0] = wavesController.NewSubWave(15);
    wave.currentSubWave = wave.subWaves[0];
    wave.frequency = frequency;
    wave.duration = duration;

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

wavesController.PopulateWaves = function()
    local waves = {};

    waves[0] = wavesController.NewWave(3, 9);
    waves[1] = wavesController.NewWave(4, 12);

    return waves;
end

return wavesController;