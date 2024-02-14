-- Force des waves basées sur le lvl du hero
-- Vague(1, 2, 3...) subdivisée en minivague (1.1, 1.2, 1.3...)
-- Nombre donné dans une wave => en mob par seconde
-- Déterminer un temps de spawn (durée au bout de laquelle la vague 1.2 pop)

-- Placer des spawn points sur la carte
local wavesController = {};
wavesController.waves = {};
wavesController.currentWave = 0;
wavesController.currentSubWave = 0;

wavesController.NewWave = function()
end

wavesController.NewSubWave = function()
end

return wavesController;