screenWidth = love.graphics.getWidth();
screenHeight = love.graphics.getHeight();

cameraOffsetX = 0;
cameraOffsetY = 0;

function GetScreenCenterPosition()
    local screenCenterX = screenWidth * 0.5 + cameraOffsetX;
    local screenCenterY = screenHeight * 0.5 + cameraOffsetY;

    return Vector.New(screenCenterX, screenCenterY);
end

function GetMousePos()
    return Vector.New(love.mouse.getX(), love.mouse.getY());
end

function GetDistance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2)^2 + (y1 - y2)^2);
end

function ReplaceMouseCrosshair(img)
    love.mouse.setVisible(false);
    love.graphics.draw(img, GetMousePos().x, GetMousePos().y, 0, 0.75, 0.75, img:getWidth()*0.5, img:getHeight()*0.5);
end