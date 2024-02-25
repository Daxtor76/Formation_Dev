local Anim = {};

function Anim:New(width, height, from, to, duration, loop)
    local tmpAnim = {};
    setmetatable(tmpAnim, {__index = Anim});

    tmpAnim.size = Vector.New(width, height);
    tmpAnim.frames = Vector.New(from, to);
    tmpAnim.duration = duration;
    tmpAnim.loop = loop;
    
    tmpAnim.framesCount = tmpAnim.frames.y - tmpAnim.frames.x + 1;
    tmpAnim.currentTimer = tmpAnim.duration / tmpAnim.framesCount;
    tmpAnim.isOver = false;
    return tmpAnim;
end

function Anim:ResetTimer()
    self.currentTimer = self.duration / self.framesCount;
end

return Anim;