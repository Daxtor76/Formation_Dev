local SpawnPoint = {};

function SpawnPoint:New(position)
    local spawnPoint = {};
    setmetatable(spawnPoint, {__index = SpawnPoint});

    spawnPoint.position = position;

    return spawnPoint;
end

return SpawnPoint;