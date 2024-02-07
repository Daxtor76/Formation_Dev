-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("utils/utils");
require("utils/vector");

SceneController = require("scenes/sceneController")
require("scenes/menuScene")
require("scenes/gameScene")

function love.load()
    SceneController.SetCurrentScene("Game");
    SceneController.LoadCurrentScene();
end

function love.update(dt)
    SceneController.UpdateCurrentScene(dt);
end

function love.draw()
    SceneController.DrawCurrentScene();
end

function love.keypressed(key)
    SceneController.KeyPressedCurrentScene(key);
end

function love.mousepressed(x, y, button)
    SceneController.MouseButtonPressedCurrentScene(button);
end

function love.mousereleased(x, y, button)
    SceneController.MouseButtonReleasedCurrentScene(button);
end
