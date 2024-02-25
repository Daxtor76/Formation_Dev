local Wave = require("constructors/Wave");

local WavesController = {};

function WavesController:New()
    local wavesController = {};
    setmetatable(wavesController, {__index = WavesController});

    wavesController.waves = wavesController:PopulateWaves();
    wavesController.waveCounter = 1;
    wavesController.currentWave = nil;
    wavesController.timer = 0;
    wavesController.isOver = false;

    wavesController:InitWave(1);

    table.insert(controllers, wavesController);

    return wavesController;
end

function WavesController:Update(dt)
    if self.isOver == false then
        self.timer = self.timer - dt;
        if self.timer <= 0 then
            self.waveCounter = self.waveCounter + 1;
            if self.waves[self.waveCounter] ~= nil then
                self:InitWave(self.waveCounter);
            else
                self.isOver = true;
            end
        end
        self.currentWave:UpdateSubWave(dt);
    end
end

function WavesController:InitWave(waveId)
    print("new wave");
    self.currentWave = self.waves[waveId];
    self.timer = self.currentWave.duration;
    self.currentWave:SpawnEnemies(self.currentWave.enemiesAmount)
end

function WavesController:ResetWaves()
    self.waveCounter = 1;
    self.currentWave = nil;
    self.timer = 0;
    self.isOver = false;
end

function WavesController:PopulateWaves()
    local waves = {};

    waves[1] = Wave:NewWave(20, 20, 3);
    waves[2] = Wave:NewWave(15, 45, 3);
    waves[3] = Wave:NewWave(8, 40, 5);
    waves[4] = Wave:NewWave(7, 42, 6);
    waves[5] = Wave:NewWave(7, 42, 7);
    waves[6] = Wave:NewWave(7, 42, 8);

    return waves
end

return WavesController;