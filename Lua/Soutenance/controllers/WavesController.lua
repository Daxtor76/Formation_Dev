local Cyclope = require("entities/enemies/Cyclope");
local Sorceress = require("entities/enemies/Sorceress");

local wavesController = {};
wavesController.waves = {};
wavesController.waveCounter = 0;
wavesController.currentWave = wavesController.waves[0];
wavesController.timer = 0;
wavesController.isOver = false;

wavesController.ResetWaves = function()
    wavesController.waveCounter = 0;
    wavesController.currentWave = wavesController.waves[0];
    wavesController.timer = 0;
    wavesController.isOver = false;
end

wavesController.NewWave = function(frequency, duration, enemiesAmount)
    local wave = {};
    wave.frequency = frequency;
    wave.duration = duration;
    wave.timer = wave.frequency;

    wave.InitSubWave = function()
        print("new sub wave")
        wave.timer = wave.frequency;
        local subwave = wavesController.NewSubWave(enemiesAmount);
        subwave.SpawnEnemies();
    end

    wave.UpdateSubWave = function(dt)
        wave.timer = wave.timer - dt;
        if wave.timer <= 0 then
            wave.InitSubWave();
        end
    end

    return wave;
end

wavesController.InitWave = function(waveId)
    print("new wave")
    wavesController.currentWave = wavesController.waves[waveId];
    wavesController.timer = wavesController.currentWave.duration;
    wavesController.currentWave.InitSubWave(waveId);
end

wavesController.UpdateWave = function(dt)
    if wavesController.isOver == false then
        wavesController.timer = wavesController.timer - dt;
        if wavesController.timer <= 0 then
            wavesController.waveCounter = wavesController.waveCounter + 1;
            if wavesController.waves[wavesController.waveCounter] ~= nil then
                wavesController.InitWave(wavesController.waveCounter);
            else
                wavesController.isOver = true;
            end
        end
        wavesController.currentWave.UpdateSubWave(dt); 
    end
end

wavesController.NewSubWave = function(enemiesAmount)
    local subWave = {};
    subWave.SpawnEnemies = function()
        for i = 0, enemiesAmount - 1 do
            local randEnemyType = love.math.random(0, 1);
            local randSpawnPoint = love.math.random(1, #bg.spawnPoints);
            enemiesCount = enemiesCount + 1;
            if randEnemyType == 0 then
                Cyclope:New(bg.spawnPoints[randSpawnPoint].position.x, bg.spawnPoints[randSpawnPoint].position.y);
            else
                Sorceress:New(bg.spawnPoints[randSpawnPoint].position.x, bg.spawnPoints[randSpawnPoint].position.y);
            end
        end
    end

    return subWave;
end

wavesController.waves[0] = wavesController.NewWave(20, 20, 3);
wavesController.waves[1] = wavesController.NewWave(15, 45, 3);
wavesController.waves[2] = wavesController.NewWave(8, 40, 5);
wavesController.waves[3] = wavesController.NewWave(7, 42, 6);
wavesController.waves[4] = wavesController.NewWave(7, 42, 7);
wavesController.waves[5] = wavesController.NewWave(7, 42, 8);

return wavesController;