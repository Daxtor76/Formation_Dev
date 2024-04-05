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
        public Ball mainBall;

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
            mainBall = new Ball(350.0f, "Ball");

            Wall wallTop = new Wall(new Vector2(0, 0), "WallTop", new Vector2(Utils.GetScreenSize().X, 2));
            Wall wallRight = new Wall(new Vector2(Utils.GetScreenSize().X - 2, 0), "WallRight", new Vector2(2, Utils.GetScreenSize().Y));
            Wall wallBottom = new Wall(new Vector2(0, Utils.GetScreenSize().Y - 2), "WallBottom", new Vector2(Utils.GetScreenSize().X, 2));
            Wall wallLeft = new Wall(new Vector2(0, 0), "WallLeft", new Vector2(2, Utils.GetScreenSize().Y));

            Teleporter tp = new Teleporter(new Vector2(100, 500), Utils.DegreesToRad(-45.0f), "Portal2", new Vector2(1, -1), "Portal");
            Teleporter tp2 = new Teleporter(new Vector2(1000, 500), Utils.DegreesToRad(45.0f), "Portal", new Vector2(-1, -1), "Portal2");

            ServiceLocator.GetService<ILevelManager>().ChangeLevel(1);

            Debug.WriteLine($"{name} scene has been loaded.");
            base.Load();
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            if (ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<Ball>().Count <= 0)
                mainBall = new Ball(350.0f, "Ball");
        }

        public override void Draw()
        {
            base.Draw();
        }

        public override void Unload()
        {
            base.Unload();
        }
    }
}
