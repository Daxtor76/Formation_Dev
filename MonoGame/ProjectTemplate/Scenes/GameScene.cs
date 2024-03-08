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

namespace ProjectTemplate
{
    class GameScene : Scene
    {
        public Hero hero;

        public GameScene(MainGame pProjectGame, string pName) : base(pProjectGame, pName)
        {
        }

        public override void Load()
        {
            base.Load();
            hero = new Hero(projectGame, projectGame.Content.Load<Texture2D>("Hero/personnage"), new Vector2(100, 100), "Hero", "Hero");

            Collider test = new Collider(projectGame, new Vector2(400, 150), new Vector2(75, 75));
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
