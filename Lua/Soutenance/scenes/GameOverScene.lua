local gameOverScene = SceneController.NewScene("GameOver");
local Button = require("UI/Button");
local Text = require("UI/Text");

local Buttons = {};
local Texts = {};

gameOverScene.Load = function(test)
    Victory = function()
        if SceneController.scenes["Game"].CheckVictory() then
            return "Congratulations !";
        end
        return "Defeat :'("
    end
    enemiesDead = enemiesKilled or 0;
    timePlayed = gameTime or 0;
    
    Texts[0] = Text:NewTitle(screenWidth * 0.5, 50, Victory());
    Texts[1] = Text:NewMiddle(screenWidth * 0.5, 100, "Enemies killed: "..enemiesDead);
    Texts[2] = Text:NewMiddle(screenWidth * 0.5, 130, "Time played: "..math.ceil(timePlayed).."s");

    Buttons[0] = Button:New(screenWidth * 0.25, screenHeight * 0.5, 100, 50, "Main menu", gameOverScene.OnMenuButtonClicked);
    Buttons[1] = Button:New(screenWidth * 0.75 - 100, screenHeight * 0.5, 100, 50, "Reload", gameOverScene.OnReloadButtonClicked);
end

gameOverScene.Update = function(dt)
    gameOverScene.CheckButtons();
end

gameOverScene.Draw = function()
    ReplaceMouseCrosshair(true);

    gameOverScene.DrawUI();
end

gameOverScene.Unload = function()
    Victory = nil;
    enemiesDead = nil;
    timePlayed = nil;
    normalFont = nil;
    middleFont = nil;
    bigFont = nil;
    Texts = nil;
    Buttons = nil;
end

gameOverScene.DrawUI = function()
    for key, value in pairs(Buttons) do
        value:Draw();
    end
    for key, value in pairs(Texts) do
        value:Draw();
    end
end

gameOverScene.CheckButtons = function()
    for key, value in pairs(Buttons) do
        if value:CheckHover() then
            if value:CheckClick() then
                value:applyButtonEffect();
            end
        end
    end
end

gameOverScene.OnMenuButtonClicked = function()
    SceneController.SetCurrentScene("Menu");
    SceneController.LoadCurrentScene();
end

gameOverScene.OnReloadButtonClicked = function()
    print("new game")
end

return gameOverScene;