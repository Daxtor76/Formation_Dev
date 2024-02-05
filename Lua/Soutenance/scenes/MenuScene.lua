local menuScene = SceneController.NewScene("Menu");

menuScene.Update = function()
    print(menuScene.name);
end

menuScene.Draw = function()
end

return menuScene;