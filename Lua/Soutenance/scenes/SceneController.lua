local sceneController = {};
sceneController.scenes = {};
sceneController.currentScene = nil;

sceneController.NewScene = function(sceneName)
    local scene = {};
    scene.name = sceneName;

    scene.Update = function()
    end;

    scene.Draw = function()
    end;

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

sceneController.UpdateCurrentScene = function()
    sceneController.currentScene.Update();
end

sceneController.DrawCurrentScene = function()
    sceneController.currentScene.Draw();
end

return sceneController;