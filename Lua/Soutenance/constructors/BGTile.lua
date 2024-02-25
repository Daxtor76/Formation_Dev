local Tile = {};

function Tile:New(img, position, size, pivot)
    local tile = {};
    tile.img = img;
    tile.position = position;
    tile.size = size;
    tile.rotation = math.rad(math.floor(love.math.random(0, 3)) * 90);
    tile.pivot = pivot;

    return tile;
end

return Tile;