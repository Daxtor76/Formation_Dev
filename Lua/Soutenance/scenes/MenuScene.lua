local menuScene = SceneController.NewScene("Menu");
local Button = require("UI/Button");
local Text = require("UI/Text");

local Buttons = {};
local Texts = {};

menuScene.Load = function()
    Texts[0] = Text:NewTitle(screenWidth * 0.5, 50, "Soutenance Lua");
    Buttons[0] = Button:New(screenWidth * 0.5 - 50, screenHeight * 0.5, 100, 50, "Launch Game", menuScene.OnGameButtonClicked);
end

menuScene.Update = function(dt)
    menuScene.CheckButtons();
end

menuScene.Draw = function()
    menuScene.DrawUI();
end

menuScene.Unload = function()
    Buttons = nil;
    Texts = nil;
end

menuScene.DrawUI = function()
    for key, value in pairs(Buttons) do
        value:Draw();
    end
    for key, value in pairs(Texts) do
        value:Draw();
    end
end

menuScene.CheckButtons = function()
    for key, value in pairs(Buttons) do
        if value:CheckHover() then
            if value:CheckClick() then
                value:applyButtonEffect();
            end
        end
    end
end

menuScene.OnGameButtonClicked = function()
    SceneController.SetCurrentScene("Game");
    SceneController.LoadCurrentScene();
end

return menuScene;