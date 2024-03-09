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

namespace ProjectTemplate
{
    class GameScene : Scene
    {
        public Paddle hero;

        public GameScene(string pName) : base(pName)
        {
        }

        public override void Load()
        {
            base.Load();
            hero = new Paddle(MainGame._content.Load<Texture2D>("Paddle/paddle_grey"), Utils.GetPaddleSpawnPosition(), 400.0f, "Paddle", "Paddle");

            Debug.WriteLine($"{name} scene has been loaded.");
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            EntityController.UpdateEntities(gameTime);
            CollisionController.UpdateColliders(gameTime);
        }

        public override void Draw(GameTime gameTime)
        {
            base.Draw(gameTime);

            EntityController.DrawEntities(gameTime);
            CollisionController.DrawColliders();
        }

        public override void Unload()
        {
            base.Unload();
        }
    }
}
