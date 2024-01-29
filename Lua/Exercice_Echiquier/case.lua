local Case = {};

function Case:New(x, y, width, height, posX, posY, name)

    local tmpCase = {};
    setmetatable(tmpCase, {__index = Case});
    tmpCase.x = x;
    tmpCase.y = y;
    tmpCase.width = width;
    tmpCase.height = height;
    tmpCase.posX = posX;
    tmpCase.posY = posY;
    tmpCase.name = name;

    print("Create instance: Case "..tmpCase.name.." ("..tmpCase.x..", "..tmpCase.y..", "..tmpCase.width..", "..tmpCase.height..", "..tmpCase.posX..", "..tmpCase.posY..")");

    return tmpCase;
end

return Case;