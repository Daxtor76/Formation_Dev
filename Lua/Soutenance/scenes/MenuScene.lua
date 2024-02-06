local menuScene = SceneController.NewScene("Menu");

menuScene.Update = function(dt)
    print(menuScene.name);
end

menuScene.Draw = function()
end

return menuScene;