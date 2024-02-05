local gameScene = SceneController.NewScene("Game");

gameScene.Update = function()
    print(gameScene.name);
end

gameScene.Draw = function()
end

return gameScene;