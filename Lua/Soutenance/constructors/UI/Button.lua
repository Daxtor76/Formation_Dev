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
    tmpButton.canBeClicked = false;
    tmpButton.isClicked = false;

    return tmpButton;
end

function Button:Draw()
    love.graphics.setFont(normalFont)
    love.graphics.setColor(love.math.colorFromBytes(self.currentColor));
    love.graphics.rectangle("fill", self.position.x - self.baseSize.x * 0.5, self.position.y - self.baseSize.y * 0.5, self.size.x, self.size.y);
    love.graphics.setColor(0, 0, 0, 1);
    love.graphics.draw(self.text, self.position.x - self.text:getWidth() * 0.5, self.position.y - self.text:getHeight() * 0.5);
    love.graphics.setColor(255, 255, 255, 1);
end

function Button:CheckHover()
    if GetMousePos().x < self.position.x + self.baseSize.x * 0.5 and
    GetMousePos().x > self.position.x - self.baseSize.x * 0.5 and
    GetMousePos().y < self.position.y + self.size.y * 0.5 and
    GetMousePos().y > self.position.y - self.baseSize.y * 0.5 then
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
        if self.canBeClicked then
            if self.isClicked == false then
                self:onClick()
                return true;
            end
            return false;
        end
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
    if love.mouse.isDown(1) == false then
        self.canBeClicked = true;
    end
end

function Button.NotHover(self)
    self.currentColor = self.baseColor;
    self.isHover = false;
    self.canBeClicked = false;
end

return Button;