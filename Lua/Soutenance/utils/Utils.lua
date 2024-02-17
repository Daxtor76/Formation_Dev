screenWidth = love.graphics.getWidth();
screenHeight = love.graphics.getHeight();

debugMode = true;

function GetScreenCenterPosition()
    local screenCenterX = screenWidth * 0.5 + cameraOffset.x;
    local screenCenterY = screenHeight * 0.5 + cameraOffset.y;

    return Vector.New(screenCenterX, screenCenterY);
end

function GetMousePos()
    return Vector.New(love.mouse.getX(), love.mouse.getY());
end

function GetDistance(pos1, pos2)
    return math.sqrt((pos1.x - pos2.x)^2 + (pos1.y - pos2.y)^2);
end

function ReplaceMouseCrosshair(img)
    love.mouse.setVisible(false);
    love.graphics.draw(img, GetMousePos().x, GetMousePos().y, 0, 0.5, 0.5, img:getWidth()*0.5, img:getHeight()*0.5);
end

function GetSign(n) 
    return n > 0 and 1 or n < 0 and -1 or 0;
end

function Clamp(value, min, max)
    if value < min then
        return min;
    elseif value > max then
        return max;
    end
    return value;
end

function ConvertRadTo360Degrees(angle)
    return (math.deg(angle)+360)%360;
end