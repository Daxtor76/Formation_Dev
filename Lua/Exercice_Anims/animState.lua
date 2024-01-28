local AnimState = {};

function AnimState:New(width, height, from, to, speed, playMode)
    local tmpAnimState = {};
    setmetatable(tmpAnimState, {__index = Dino});

    tmpAnimState.width = width;
    tmpAnimState.height = height;
    tmpAnimState.from = from;
    tmpAnimState.to = to;
    tmpAnimState.speed = speed;
    tmpAnimState.playMode = playMode;
    return tmpAnimState;
end

return AnimState;