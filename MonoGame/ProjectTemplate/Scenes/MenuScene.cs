using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Scenes
{
    class MenuScene : Scene
    {
        public MenuScene(string pName) : base(pName)
        {
        }

        public override void Load()
        {
            base.Load();
            Debug.WriteLine($"{name} scene has been loaded.");
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            if(Keyboard.GetState().IsKeyDown(Keys.Space))
            {
                SceneController.ChangeScene(SceneController.SceneType.Game);
            }
        }

        public override void Draw(GameTime gameTime)
        {
            base.Draw(gameTime);
        }

        public override void Unload()
        {
            base.Unload();
        }
    }
}
