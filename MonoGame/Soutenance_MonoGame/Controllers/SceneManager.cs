﻿using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Soutenance_MonoGame.Interfaces;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public sealed class SceneManager : ISceneManager
    {
        Dictionary<Type, Scene> scenes = new Dictionary<Type, Scene>();
        Scene currentScene;

        public SceneManager()
        {
            ServiceLocator.RegisterService<ISceneManager>(this);
            Init();
        }

        public void Init()
        {
            Scene menuScene = new MenuScene("Menu");
            Scene gameScene = new GameScene("Game");
            Scene gameOverScene = new GameOverScene("GameOver");

            scenes.Add(typeof(MenuScene), menuScene);
            scenes.Add(typeof(GameScene), gameScene);
            scenes.Add(typeof(GameOverScene), gameOverScene);

            // To be changed by menuscene after
            ChangeScene(typeof(GameScene));
        }

        public void ChangeScene(Type sceneType)
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
