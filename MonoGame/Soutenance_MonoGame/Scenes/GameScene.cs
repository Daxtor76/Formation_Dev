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
            new CollisionManager();
            new SpritesManager();
            new KeyboardInputManager();
            new LevelManager();

            paddle = new Paddle(Paddle.Colors.grey, 400.0f, "Paddle");
            ball = new Ball(Ball.Colors.red, 350.0f, "Ball");

            Wall wallTop = new Wall(new Vector2(0, 0), "WallTop", new Vector2(Utils.GetScreenSize().X, 2));
            Wall wallRight = new Wall(new Vector2(Utils.GetScreenSize().X - 2, 0), "WallRight", new Vector2(2, Utils.GetScreenSize().Y));
            Wall wallBottom = new Wall(new Vector2(0, Utils.GetScreenSize().Y - 2), "WallBottom", new Vector2(Utils.GetScreenSize().X, 2));
            Wall wallLeft = new Wall(new Vector2(0, 0), "WallLeft", new Vector2(2, Utils.GetScreenSize().Y));

            Teleporter tp = new Teleporter(new Vector2(100, 500), 0.0f, "Portal2", Vector2.UnitX, "Portal");
            Teleporter tp2 = new Teleporter(new Vector2(1000, 500), Utils.DegreesToRad(45.0f), "Portal", new Vector2(-1, -1), "Portal2");

            //Brick brick = new NormalBrick(Brick.BrickTypes.bigbrick, Brick.Colors.red, "brickfjzievjzruo");

            Debug.WriteLine($"{name} scene has been loaded.");
            base.Load();
        }

        public override void Start()
        {
            paddle.ball = ball;
            ball.paddle = paddle;
            ServiceLocator.GetService<ILevelManager>().ChangeLevel(1);

            base.Start();
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            ServiceLocator.GetService<IEntityManager>().UpdateEntities(gameTime);
            ServiceLocator.GetService<ICollisionManager>().UpdateColliders(gameTime);
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
