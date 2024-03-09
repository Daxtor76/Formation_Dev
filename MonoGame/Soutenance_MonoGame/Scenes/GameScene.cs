using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ProjectTemplate.Constructors;
using Microsoft.Xna.Framework.Graphics;
using ProjectTemplate.Controllers;
using ProjectTemplate.Entities;
using ProjectTemplate.Interfaces;
using Soutenance_MonoGame.Utils;
using Soutenance_MonoGame.Entities;

namespace ProjectTemplate
{
    class GameScene : Scene
    {
        public Paddle paddle;
        public Ball ball;

        public GameScene(string pName) : base(pName)
        {
        }

        public override void Load()
        {
            base.Load();
            paddle = new Paddle(MainGame._content.Load<Texture2D>("Paddle/paddle_grey"), Utils.GetPaddleSpawnPosition(), 400.0f, "Paddle", "Paddle");
            ball = new Ball(MainGame._content.Load<Texture2D>("Ball/ball_orange"), Utils.GetScreenCenter(), 300.0f, new Vector2(0, 1), "Ball", "Ball");

            Wall wallTop = new Wall(new Vector2(Utils.GetScreenCenter().X, 0), "Wall", new Vector2(Utils.GetScreenSize().X, 2));
            Wall wallLeft = new Wall(new Vector2(0, Utils.GetScreenCenter().Y), "Wall", new Vector2(2, Utils.GetScreenSize().Y));
            Wall wallRight = new Wall(new Vector2(Utils.GetScreenSize().X - 2, Utils.GetScreenCenter().Y), "Wall", new Vector2(2, Utils.GetScreenSize().Y));

            Debug.WriteLine($"{name} scene has been loaded.");
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            EntityController.UpdateEntities(gameTime);
            CollisionController.UpdateColliders();
        }

        public override void Draw()
        {
            base.Draw();

            EntityController.DrawEntities();
            CollisionController.DrawColliders();
        }

        public override void Unload()
        {
            base.Unload();
        }
    }
}
