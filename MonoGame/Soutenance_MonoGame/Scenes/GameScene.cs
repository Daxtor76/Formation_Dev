using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using Vector2 = System.Numerics.Vector2;
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
            paddle = new Paddle(Paddle.Colors.yellow, 400.0f, "Paddle");
            ball = new Ball(Ball.Colors.red, 500.0f, new Vector2(0, 1), "Ball");

            Wall wallTop = new Wall(new Vector2(0, 0), "Wall", new Vector2(Utils.GetScreenSize().X, 2));
            Wall wallBottom = new Wall(new Vector2(0, Utils.GetScreenSize().Y - 2), "Wall", new Vector2(Utils.GetScreenSize().X, 2));
            Wall wallLeft = new Wall(new Vector2(0, 0), "Wall", new Vector2(2, Utils.GetScreenSize().Y));
            Wall wallRight = new Wall(new Vector2(Utils.GetScreenSize().X - 2, 0), "Wall", new Vector2(2, Utils.GetScreenSize().Y));

            Brick brick = new Brick(Brick.BrickTypes.littlebrick, Brick.Colors.grey, new Vector2(1, 10), "Brick1");
            Brick brick2 = new Brick(Brick.BrickTypes.littlebrick, Brick.Colors.green, new Vector2(200, 10), "Brick2");
            Brick brick3 = new Brick(Brick.BrickTypes.littlebrick, Brick.Colors.yellow, new Vector2(450, 10), "Brick3");
            Brick brick4 = new Brick(Brick.BrickTypes.brick, Brick.Colors.orange, new Vector2(900, 150), "Brick4");
            Brick brick5 = new Brick(Brick.BrickTypes.brick, Brick.Colors.red, new Vector2(500, 150), "Brick5");
            Brick brick6 = new Brick(Brick.BrickTypes.brick, Brick.Colors.purple, new Vector2(1000, 150), "Brick6");
            Brick brick7 = new Brick(Brick.BrickTypes.bigbrick, Brick.Colors.green, new Vector2(100, 300), "Brick7");
            Brick brick8 = new Brick(Brick.BrickTypes.bigbrick, Brick.Colors.orange, new Vector2(750, 300), "Brick8");
            Brick brick9 = new Brick(Brick.BrickTypes.bigbrick, Brick.Colors.purple, new Vector2(1050, 300), "Brick9");

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
