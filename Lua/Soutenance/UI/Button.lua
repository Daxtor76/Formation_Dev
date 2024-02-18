local Button = {};

function Button:New(x, y, w, h, label, event)
    local tmpButton = {};
    setmetatable(tmpButton, {__index = Button});

    tmpButton.position = Vector.New(x, y);
    tmpButton.baseSize = Vector.New(w, h);
    tmpButton.size = tmpButton.baseSize;

    love.graphics.setFont(normalFont);
    tmpButton.font = love.graphics.getFont();
    tmpButton.text = love.graphics.newText(tmpButton.font, label);

    tmpButton.baseColor = {255, 255, 255, 255};
    tmpButton.hoverColor = {200, 200, 200, 255};
    tmpButton.currentColor = tmpButton.baseColor;

    tmpButton.onClick = Button.OnClick;
    tmpButton.onNotClick = Button.NotClick;
    tmpButton.onHover = Button.OnHover;
    tmpButton.onNotHover = Button.NotHover;
    tmpButton.applyButtonEffect = event;

    tmpButton.isHover = false;
    tmpButton.isClicked = false;

    return tmpButton;
end

function Button:Draw()
    love.graphics.setFont(normalFont)
    love.graphics.setColor(love.math.colorFromBytes(self.currentColor));
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y);
    love.graphics.setColor(0, 0, 0, 1);
    love.graphics.draw(self.text, self.position.x + self.size.x * 0.5 - self.text:getWidth() * 0.5, self.position.y + self.size.y * 0.5 - self.text:getHeight() * 0.5);
    love.graphics.setColor(255, 255, 255, 1);
end

function Button:CheckHover()
    if GetMousePos().x < self.position.x + self.size.x and
    GetMousePos().x > self.position.x and
    GetMousePos().y < self.position.y + self.size.y and
    GetMousePos().y > self.position.y then
        if self.isHover == false then
            self:onHover();
        end
        return true;
    else
        if self.isHover then
            self:onNotHover();
        end
        return false;
    end
    return false;
end

function Button:CheckClick()
    if love.mouse.isDown(1) then
        if self.isClicked == false then
            self:onClick()
            return true;
        end
        return false;
    else
        if self.isClicked then
            self:onNotClick();
        end
    end
    return false;
end

function Button.OnClick(self)
    self.size = self.baseSize * 0.95;
    self.isClicked = true;
end

function Button.NotClick(self)
    self.size = self.baseSize;
    self.isClicked = false;
end

function Button.OnHover(self)
    self.currentColor = self.hoverColor;
    self.isHover = true;
end

function Button.NotHover(self)
    self.currentColor = self.baseColor;
    self.isHover = false;
end

return Button;