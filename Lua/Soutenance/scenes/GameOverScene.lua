local gameOverScene = SceneController.NewScene("GameOver");

local buttons = nil;
local texts = nil;

gameOverScene.Load = function(test)
    buttons = {};
    texts = {};
    Victory = function()
        if SceneController.scenes["Game"].CheckVictory() then
            return "Congratulations !";
        end
        return "Defeat :'("
    end
    enemiesDead = enemiesKilled or -1;
    timePlayed = gameTime or -1;
    
    texts[1] = Text:NewTitle(screenWidth * 0.5, 50, Victory());
    texts[2] = Text:NewMiddle(screenWidth * 0.5, 100, "Enemies killed: "..enemiesDead);
    texts[3] = Text:NewMiddle(screenWidth * 0.5, 130, "Time played: "..math.ceil(timePlayed).."s");

    buttons[1] = Button:New(screenWidth * 0.25, screenHeight * 0.5, 100, 50, "Main menu", gameOverScene.OnMenuButtonClicked);
    buttons[2] = Button:New(screenWidth * 0.75, screenHeight * 0.5, 100, 50, "Reload", gameOverScene.OnReloadButtonClicked);
end

gameOverScene.Update = function(dt)
    gameOverScene.Checkbuttons();
end

gameOverScene.Draw = function()
    ReplaceMouseCrosshair(true);

    gameOverScene.DrawUI();
end

gameOverScene.Unload = function()
    Victory = nil;
    enemiesDead = nil;
    timePlayed = nil;
    texts = nil;
    buttons = nil;
end

gameOverScene.DrawUI = function()
    for __, value in ipairs(buttons) do
        value:Draw();
    end
    for __, value in ipairs(texts) do
        value:Draw();
    end
end

gameOverScene.Checkbuttons = function()
    for __, value in ipairs(buttons) do
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
    SceneController.SetCurrentScene("Game");
    SceneController.LoadCurrentScene();
end

return gameOverScene;