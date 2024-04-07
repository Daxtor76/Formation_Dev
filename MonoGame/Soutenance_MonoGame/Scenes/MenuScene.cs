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
using System.Reflection.Emit;

namespace Soutenance_MonoGame
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

            if(ServiceLocator.GetService<IInputManager>().KeyPressed(Keys.Space))
            {
                ServiceLocator.GetService<ISceneManager>().SetCurrentScene(typeof(GameScene));
                ServiceLocator.GetService<ILevelManager>().ChangeLevel(1);
            }
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
