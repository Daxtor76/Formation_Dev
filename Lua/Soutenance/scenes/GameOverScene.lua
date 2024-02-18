local gameOverScene = SceneController.NewScene("GameOver");
local Button = require("UI/Button");

local Buttons = {};

gameOverScene.Load = function(test)
    --victory = SceneController.scenes["Game"].CheckVictory();
    --enemiesKilleddeze = enemiesKilled;
    --gameTimevrbvte = math.ceil(gameTime);

    Buttons[0] = Button:New(200, 200, 100, 50, "Main menu", gameOverScene.OnMenuButtonClicked);
    Buttons[1] = Button:New(400, 200, 100, 50, "Reload", gameOverScene.OnReloadButtonClicked);
end

gameOverScene.Update = function(dt)
    gameOverScene.CheckButtons();
end

gameOverScene.Draw = function()
    --ReplaceMouseCrosshair(true);
    --if victory then
    --    love.graphics.print("Victory!", 0, 0);
    --else
    --    love.graphics.print("Defeat :(", 0, 0);
    --end
    --love.graphics.print("Enemies killed: "..enemiesKilled, 0, 15);
    --love.graphics.print("Time played: "..gameTimevrbvte.."s", 0, 30);

    for key, value in pairs(Buttons) do
        value:Draw();
    end
end

gameOverScene.Unload = function()
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
    print("load menu scene")
end

gameOverScene.OnReloadButtonClicked = function()
    print("new game")
end

return gameOverScene;