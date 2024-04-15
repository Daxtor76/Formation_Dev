﻿using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Xna.Framework.Graphics;
using System.Text.Json.Nodes;
using System.Reflection.Emit;
using System.Text.Json;
using System.Diagnostics.Metrics;

namespace Soutenance_MonoGame
{
    class GameScene : Scene
    {
        public Paddle paddle;
        public Ball mainBall;

        public VictoryManager victoryManager;
        List<Heart> hearts;

        public GameScene(string pName) : base(pName)
        {
        }

        public override void Load()
        {
            hearts = new List<Heart>();
            paddle = new Paddle(Paddle.Colors.grey, 400.0f, "Paddle");
            mainBall = new Ball(250.0f, "Ball");

            Wall wallTop = new Wall(new Vector2(0, 0), "WallTop", new Vector2(Utils.GetScreenSize().X, 2));
            Wall wallRight = new Wall(new Vector2(Utils.GetScreenSize().X - 2, 0), "WallRight", new Vector2(2, Utils.GetScreenSize().Y));
            Wall wallBottom = new Wall(new Vector2(0, Utils.GetScreenSize().Y - 2), "WallBottom", new Vector2(Utils.GetScreenSize().X, 2));
            Wall wallLeft = new Wall(new Vector2(0, 0), "WallLeft", new Vector2(2, Utils.GetScreenSize().Y));

            victoryManager = new VictoryManager();

            CreateHeartsPerLifepoints(victoryManager.GetPlayerLife() - 1);

            Debug.WriteLine($"{name} scene has been loaded.");
            base.Load();
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            victoryManager.AddGameDuration((float)gameTime.ElapsedGameTime.TotalSeconds);
            if (ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<Ball>().Count <= 0)
            {
                RemoveHeart();
                victoryManager.DecreasePlayerLife(1);
                foreach (Teleporter tp in ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<Teleporter>())
                {
                    if (tp.IsActive())
                        tp.col.SetActive(true);
                }
                if (victoryManager.GetPlayerLife() <= 0)
                {
                    victoryManager.StoreGameData();
                    ServiceLocator.GetService<ISceneManager>().SetCurrentScene(typeof(GameOverScene));
                    return;
                }

                mainBall = new Ball(250.0f, "Ball");
            }

            if (victoryManager.Victory())
            {
                victoryManager.StoreGameData();
                ServiceLocator.GetService<ISceneManager>().SetCurrentScene(typeof(GameOverScene));
            }
        }

        public override void Unload()
        {
            paddle = null;
            mainBall = null;
            victoryManager = null;
            hearts = null;
            base.Unload();
        }

        private void CreateHeartsPerLifepoints(int lp)
        {
            Vector2 screenSize = Utils.GetScreenSize();
            for (int i = 0; i < lp; i++)
            {
                Heart heart = new Heart();
                heart.SetPosition(new Vector2(i * heart.GetSize().X, screenSize.Y - heart.GetSize().Y));
                hearts.Add(heart);
            }
        }

        void RemoveHeart()
        {
            if (victoryManager.GetPlayerLife() - 2 >= 0 && hearts[victoryManager.GetPlayerLife() - 2] != null)
            {
                hearts[victoryManager.GetPlayerLife() - 2].Destroy();
                hearts[victoryManager.GetPlayerLife() - 2] = null;
            }
        }
    }
}
