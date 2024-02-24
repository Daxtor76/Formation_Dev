local menuScene = SceneController.NewScene("Menu");

local buttons = nil;
local texts = nil;

menuScene.Load = function()
    texts = {};
    buttons = {};

    texts[0] = Text:NewTitle(screenWidth * 0.5, 50, "Soutenance Lua");
    buttons[0] = Button:New(screenWidth * 0.5, screenHeight * 0.5, 100, 50, "Launch Game", menuScene.OnGameButtonClicked);
end

menuScene.Update = function(dt)
    menuScene.CheckButtons();
end

menuScene.Draw = function()
    menuScene.DrawUI();
end

menuScene.Unload = function()
    buttons = nil;
    texts = nil;
end

menuScene.DrawUI = function()
    for key, value in pairs(buttons) do
        value:Draw();
    end
    for key, value in pairs(texts) do
        value:Draw();
    end
end

menuScene.CheckButtons = function()
    for key, value in pairs(buttons) do
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