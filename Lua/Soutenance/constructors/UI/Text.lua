local Text = {};

function Text:New(x, y, label)
    local tmpText = {};
    setmetatable(tmpText, {__index = Text});

    tmpText.position = Vector.New(x, y);

    love.graphics.setFont(normalFont);
    tmpText.font = love.graphics.getFont();
    tmpText.text = love.graphics.newText(tmpText.font, label);

    tmpText.currentColor = {255, 255, 255, 255};

    return tmpText;
end

function Text:NewMiddle(x, y, label)
    local tmpText = {};
    setmetatable(tmpText, {__index = Text});

    tmpText.position = Vector.New(x, y);

    love.graphics.setFont(middleFont);
    tmpText.font = love.graphics.getFont();
    tmpText.text = love.graphics.newText(tmpText.font, label);

    tmpText.currentColor = {255, 255, 255, 255};

    return tmpText;
end

function Text:NewTitle(x, y, label)
    local tmpText = {};
    setmetatable(tmpText, {__index = Text});

    tmpText.position = Vector.New(x, y);

    love.graphics.setFont(bigFont);
    tmpText.font = love.graphics.getFont();
    tmpText.text = love.graphics.newText(tmpText.font, label);

    tmpText.currentColor = {255, 255, 255, 255};

    return tmpText;
end

function Text:Draw()
    love.graphics.setColor(love.math.colorFromBytes(self.currentColor));
    love.graphics.draw(self.text, self.position.x - self.text:getWidth() * 0.5, self.position.y - self.text:getHeight() * 0.5);
end

return Text;