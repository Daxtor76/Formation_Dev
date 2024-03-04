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
using ProjectTemplate.Scenes;
using ProjectTemplate.Colliders;

namespace ProjectTemplate
{
    class MenuScene : Scene
    {
        Texture2D img;
        Vector2 imgPos = new Vector2();
        Collider imgCol;

        public MenuScene(MainGame pProjectGame, string pName) : base(pProjectGame, pName)
        {
        }

        public override void Load()
        {
            base.Load();
            img = projectGame.Content.Load<Texture2D>("Hero/personnage");
            imgCol = new Collider(projectGame, new Vector2(100, 100), new Vector2(100, 100), img);
            Debug.WriteLine($"{name} scene has been loaded.");
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            imgPos.X += 100 * (float)gameTime.ElapsedGameTime.TotalSeconds;
            imgPos.X = Math.Clamp(imgPos.X, 0, 300);

            CollisionController.UpdateColliders(gameTime);

            if(Keyboard.GetState().IsKeyDown(Keys.Space))
            {
                SceneController.ChangeScene(SceneController.SceneType.Game);
            }
        }

        public override void Draw(GameTime gameTime)
        {
            base.Draw(gameTime);
            projectGame._spriteBatch.Draw(img, imgPos, Color.White);
            CollisionController.DrawColliders();
        }

        public override void Unload()
        {
            base.Unload();
        }
    }
}
