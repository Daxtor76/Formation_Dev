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

    scene.Unload = function()
    end;

    sceneController.scenes[sceneName] = scene;
    return scene;
end

sceneController.SetCurrentScene = function(sceneName)
    if sceneController.currentScene ~= nil then
        sceneController.currentScene.Unload();
    end
    if sceneController.scenes[sceneName] ~= nil then
        sceneController.currentScene = sceneController.scenes[sceneName];
    else
        error("The scene does not exist.");
    end
end

sceneController.LoadSceneAdditive = function(sceneName)
    if sceneController.scenes[sceneName] ~= nil then
        sceneController.scenes[sceneName].Load();
    else
        error("The scene does not exist so it cannot be loaded.");
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

sceneController.UnloadCurrentScene = function()
    sceneController.currentScene.Unload();
end

return sceneController;