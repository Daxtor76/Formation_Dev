-- Les fonctions de calcul

screenWidth = love.graphics.getWidth();
screenHeight = love.graphics.getHeight();

function GetMousePos()
    local mousePos = {};
    mousePos["x"] = love.mouse.getX();
    mousePos["y"] = love.mouse.getY();
    return mousePos;
end

function GetDistance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2)^2 + (y1 - y2)^2);
end