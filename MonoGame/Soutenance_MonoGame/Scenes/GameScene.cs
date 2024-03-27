using Microsoft.Xna.Framework;
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
        public Ball ball;

        public GameScene(string pName) : base(pName)
        {
        }

        public override void Load()
        {
            base.Load();
            new CollisionManager();
            new SpritesManager();
            new KeyboardInputManager();
            new LevelManager();

            paddle = new Paddle(Paddle.Colors.grey, 400.0f, "Paddle");
            ball = new Ball(Ball.Colors.red, 500.0f, "Ball");

            Wall wallTop = new Wall(new Vector2(0, 0), "WallTop", new Vector2(Utils.GetScreenSize().X, 2));
            Wall wallRight = new Wall(new Vector2(Utils.GetScreenSize().X - 2, 0), "WallRight", new Vector2(2, Utils.GetScreenSize().Y));
            Wall wallBottom = new Wall(new Vector2(0, Utils.GetScreenSize().Y - 2), "WallBottom", new Vector2(Utils.GetScreenSize().X, 2));
            Wall wallLeft = new Wall(new Vector2(0, 0), "WallLeft", new Vector2(2, Utils.GetScreenSize().Y));

            ServiceLocator.GetService<ILevelManager>().ChangeLevel(1);

            /*Brick brick = new Brick(Brick.BrickTypes.littlebrick, Brick.Colors.grey, new Vector2(180, 10), "Brick1");
            Brick brick2 = new Brick(Brick.BrickTypes.littlebrick, Brick.Colors.green, new Vector2(220, 10), "Brick2");
            Brick brick3 = new Brick(Brick.BrickTypes.littlebrick, Brick.Colors.yellow, new Vector2(450, 10), "Brick3");
            Brick brick4 = new Brick(Brick.BrickTypes.brick, Brick.Colors.orange, new Vector2(900, 150), "Brick4");
            Brick brick5 = new Brick(Brick.BrickTypes.brick, Brick.Colors.red, new Vector2(500, 150), "Brick5");
            Brick brick6 = new Brick(Brick.BrickTypes.brick, Brick.Colors.purple, new Vector2(1000, 150), "Brick6");
            Brick brick7 = new Brick(Brick.BrickTypes.bigbrick, Brick.Colors.green, new Vector2(100, 300), "Brick7");
            Brick brick8 = new Brick(Brick.BrickTypes.bigbrick, Brick.Colors.orange, new Vector2(550, 100), "Brick8");
            Brick brick9 = new Brick(Brick.BrickTypes.bigbrick, Brick.Colors.purple, new Vector2(600, 100), "Brick9");*/

            Debug.WriteLine($"{name} scene has been loaded.");
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            ServiceLocator.GetService<IEntityManager>().UpdateEntities(gameTime);
            ServiceLocator.GetService<ICollisionManager>().UpdateColliders();
        }

        public override void Draw()
        {
            base.Draw();

            ServiceLocator.GetService<IEntityManager>().DrawEntities();
            ServiceLocator.GetService<ICollisionManager>().DrawColliders();
        }

        public override void Unload()
        {
            base.Unload();
        }
    }
}
