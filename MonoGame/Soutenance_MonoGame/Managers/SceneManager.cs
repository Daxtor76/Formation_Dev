using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    sealed class SceneManager : ISceneManager
    {
        Dictionary<Type, Scene> scenes = new Dictionary<Type, Scene>();
        Scene currentScene = null;

        public SceneManager()
        {
            ServiceLocator.RegisterService<ISceneManager>(this);
            Init();
        }

        public void Init()
        {
            Scene menuScene = new MenuScene("Menu");
            Scene levelSelectionScene = new MenuScene("LevelSelection");
            Scene gameScene = new GameScene("Game");
            Scene gameOverScene = new GameOverScene("GameOver");

            scenes.Add(typeof(MenuScene), menuScene);
            scenes.Add(typeof(LevelSelectionScene), levelSelectionScene);
            scenes.Add(typeof(GameScene), gameScene);
            scenes.Add(typeof(GameOverScene), gameOverScene);

            SetCurrentScene(typeof(MenuScene));
        }

        public void SetCurrentScene(Type sceneType)
        {
            if (currentScene != null)
            {
                currentScene.Unload();
                currentScene = null;
            }

            if (scenes[sceneType] != null)
            {
                currentScene = scenes[sceneType];
                currentScene.Load();
            }
            else
                Debug.WriteLine($"Scene {sceneType.ToString()} does not exist.");
        }
        public Scene GetCurrentScene()
        {
            return currentScene;
        }
    }
}
