-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("utils/Vector");
require("utils/Utils");

SceneController = require("controllers/SceneController");
Button = require("UI/Button");
Text = require("UI/Text");

require("scenes/MenuScene");
require("scenes/GameScene");
require("scenes/GameOverScene");

function love.load()
    SceneController.SetCurrentScene("Menu");
    SceneController.LoadCurrentScene();
end

function love.update(dt)
    SceneController.UpdateCurrentScene(dt);
end

function love.draw()
    SceneController.DrawCurrentScene();
end