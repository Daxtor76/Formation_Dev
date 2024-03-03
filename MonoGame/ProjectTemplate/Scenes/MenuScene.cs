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

namespace ProjectTemplate
{
    class MenuScene : Scene
    {
        Texture2D img;
        Vector2 imgPos = new Vector2();

        public MenuScene(MainGame pProjectGame, string pName) : base(pProjectGame, pName)
        {
        }

        public override void Load()
        {
            base.Load();
            img = projectGame.Content.Load<Texture2D>("Hero/personnage");
            Debug.WriteLine($"{name} scene has been loaded.");
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            imgPos.X += 100 * (float)gameTime.ElapsedGameTime.TotalSeconds;
            imgPos.X = Math.Clamp(imgPos.X, 0, 300);
            if(Keyboard.GetState().IsKeyDown(Keys.Space))
            {
                SceneController.ChangeScene(SceneController.SceneType.Game);
            }
        }

        public override void Draw(GameTime gameTime)
        {
            base.Draw(gameTime);
            projectGame._spriteBatch.Draw(img, imgPos, Color.White);
        }

        public override void Unload()
        {
            base.Unload();
        }
    }
}
