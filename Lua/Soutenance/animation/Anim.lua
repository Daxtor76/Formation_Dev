local Anim = {};

function Anim:New(width, height, from, to, duration, loop)
    local tmpAnim = {};
    setmetatable(tmpAnim, {__index = Anim});

    tmpAnim.width = width;
    tmpAnim.height = height;
    tmpAnim.from = from;
    tmpAnim.to = to;
    tmpAnim.duration = duration;
    tmpAnim.loop = loop;
    
    tmpAnim.framesCount = tmpAnim.to - tmpAnim.from + 1;
    tmpAnim.currentTimer = tmpAnim.duration / tmpAnim.framesCount;
    tmpAnim.isOver = false;
    return tmpAnim;
end

function Anim:ResetTimer()
    self.currentTimer = self.duration / self.framesCount;
end

return Anim;