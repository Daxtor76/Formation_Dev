local SpawnPoint = {};

function SpawnPoint:New(position)
    local spawnPoint = {};
    spawnPoint.position = position;

    return spawnPoint;
end

return SpawnPoint;