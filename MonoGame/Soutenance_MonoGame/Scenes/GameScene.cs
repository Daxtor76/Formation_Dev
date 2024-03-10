using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Soutenance_MonoGame.Constructors;
using Microsoft.Xna.Framework.Graphics;
using Soutenance_MonoGame.Controllers;
using Soutenance_MonoGame.Entities;
using Soutenance_MonoGame.Interfaces;

namespace Soutenance_MonoGame
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
            paddle = new Paddle(MainGame._content.Load<Texture2D>("Paddle/paddle_grey"), 400.0f, "Paddle", "Paddle");
            ball = new Ball(MainGame._content.Load<Texture2D>("Ball/ball_orange"), 300.0f, new Vector2(0, 1), "Ball", "Ball");

            Wall wallTop = new Wall(new Vector2(0, 2), "Wall", new Vector2(Utils.GetScreenSize().X, 2));
            Wall wallLeft = new Wall(new Vector2(0, 0), "Wall", new Vector2(2, Utils.GetScreenSize().Y));
            Wall wallRight = new Wall(new Vector2(Utils.GetScreenSize().X - 2, 0), "Wall", new Vector2(2, Utils.GetScreenSize().Y));

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
