local Anim = {};

function Anim:New(width, height, from, to, speed)
    local tmpAnim = {};
    setmetatable(tmpAnim, {__index = Dino});

    tmpAnim.width = width;
    tmpAnim.height = height;
    tmpAnim.from = from;
    tmpAnim.to = to;
    tmpAnim.speed = speed;
    return tmpAnim;
end

return Anim;