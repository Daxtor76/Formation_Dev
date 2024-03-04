using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using ProjectTemplate.Constructors;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Controllers
{
    public static class SceneController
    {
        public enum SceneType
        {
            Menu,
            Game,
            GameOver
        }
        public static List<Scene> sceneList = new List<Scene>();
        public static Scene currentScene;

        public static void Init(MainGame projectGame)
        {
            // Same order as the enum
            Scene menuScene = new MenuScene(projectGame, "Menu");
            Scene gameScene = new GameScene(projectGame, "Game");
            Scene gameOverScene = new GameOverScene(projectGame, "GameOver");
            sceneList.Add(menuScene);
            sceneList.Add(gameScene);
            sceneList.Add(gameOverScene);

            ChangeScene(SceneType.Game);
        }

        public static void ChangeScene(SceneType scene)
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
