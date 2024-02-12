local Anim = {};

function Anim:New(width, height, from, to, duration, loop)
    local tmpAnim = {};

    tmpAnim.width = width;
    tmpAnim.height = height;
    tmpAnim.from = from;
    tmpAnim.to = to;
    tmpAnim.duration = duration;
    tmpAnim.loop = loop;
    
    tmpAnim.framesCount = tmpAnim.to - tmpAnim.from + 1;
    tmpAnim.currentTimer = tmpAnim.duration / tmpAnim.framesCount;
    return tmpAnim;
end

return Anim;