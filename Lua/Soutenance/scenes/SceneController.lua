local sceneController = {};
sceneController.scenes = {};
sceneController.currentScene = nil;

sceneController.NewScene = function(sceneName)
    local scene = {};
    scene.name = sceneName;

    scene.Load = function()
    end;

    scene.Update = function(dt)
    end;

    scene.Draw = function()
    end;

    scene.KeyPressed = function(key)
    end

    scene.MouseButtonPressed = function(button)
    end

    scene.MouseButtonReleased = function(button)
    end

    sceneController.scenes[sceneName] = scene;
    return scene;
end

sceneController.SetCurrentScene = function(sceneName)
    if sceneController.scenes[sceneName] ~= nil then
        sceneController.currentScene = sceneController.scenes[sceneName];
    else
        error("The scene does not exist.");
    end
end

sceneController.LoadCurrentScene = function()
    sceneController.currentScene.Load();
end

sceneController.UpdateCurrentScene = function(dt)
    sceneController.currentScene.Update(dt);
end

sceneController.DrawCurrentScene = function()
    sceneController.currentScene.Draw();
end

sceneController.KeyPressedCurrentScene = function(key)
    sceneController.currentScene.KeyPressed(key);
end

sceneController.MouseButtonPressedCurrentScene = function(button)
    sceneController.currentScene.MouseButtonPressed(button);
end

sceneController.MouseButtonReleasedCurrentScene = function(button)
    sceneController.currentScene.MouseButtonReleased(button);
end

return sceneController;