using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Mime;
using System.Text;
using System.Threading.Tasks;
using ProjectTemplate.Constructors;
using ProjectTemplate.Controllers;
using System.Reflection.Emit;

namespace ProjectTemplate
{
    public class Hero : Entity
    {
        public Texture2D img;
        public Collider col;

        public Hero(MainGame pProjectGame, Texture2D pImg, Vector2 pPos) : base(pProjectGame)
        {
            projectGame = pProjectGame;
            position = pPos;
            img = pImg;
            size = new Vector2(img.Width, img.Height);
            col = new Collider(pProjectGame, this);
        }
    }

    class MenuScene : Scene
    {
        public Hero hero;

        public MenuScene(MainGame pProjectGame, string pName) : base(pProjectGame, pName)
        {
        }

        public override void Load()
        {
            base.Load();
            hero = new Hero(projectGame, projectGame.Content.Load<Texture2D>("Hero/personnage"), new Vector2(100, 100));
            Debug.WriteLine($"{name} scene has been loaded.");
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            hero.position.X += 100 * (float)gameTime.ElapsedGameTime.TotalSeconds;
            hero.position.X = Math.Clamp(hero.position.X, 0, 300);

            CollisionController.UpdateColliders(gameTime);

            if(Keyboard.GetState().IsKeyDown(Keys.Space))
            {
                SceneController.ChangeScene(SceneController.SceneType.Game);
            }
        }

        public override void Draw(GameTime gameTime)
        {
            base.Draw(gameTime);
            projectGame._spriteBatch.Draw(hero.img, hero.position, Color.White);
            CollisionController.DrawColliders();
        }

        public override void Unload()
        {
            base.Unload();
        }
    }
}
