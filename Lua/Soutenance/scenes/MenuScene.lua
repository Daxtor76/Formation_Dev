local menuScene = SceneController.NewScene("Menu");

local buttons = nil;
local texts = nil;

menuScene.Load = function()
    texts = {};
    buttons = {};

    texts[1] = Text:NewTitle(screenWidth * 0.5, 50, "Soutenance Lua");
    buttons[1] = Button:New(screenWidth * 0.5, screenHeight * 0.5, 100, 50, "Launch Game", menuScene.OnGameButtonClicked);
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
    for __, value in ipairs(buttons) do
        value:Draw();
    end
    for __, value in ipairs(texts) do
        value:Draw();
    end
end

menuScene.CheckButtons = function()
    for __, value in ipairs(buttons) do
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