using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Scenes
{
    public class SceneController
    {
        public enum SceneType
        {
            Menu,
            Game,
            GameOver
        }
        public List<Scene> sceneList = new List<Scene>();
        public Scene currentScene;

        public void Init()
        {
            // Same order as the enum
            Scene menuScene = new MenuScene("Menu");
            Scene gameScene = new GameScene("Game");
            Scene gameOverScene = new GameOverScene("GameOver");
            sceneList.Add(menuScene);
            sceneList.Add(gameScene);
            sceneList.Add(gameOverScene);

            ChangeScene(SceneType.Menu);
        }

        public void ChangeScene(SceneType scene)
        {
            if (currentScene != null)
            {
                currentScene.Unload();
                currentScene = null;
            }

            if (sceneList[(int)scene] != null)
            {
                currentScene = sceneList[(int)scene];
                currentScene.Load();
            }
            else
                Debug.WriteLine($"Scene {scene} does not exist.");
        }
    }
}
