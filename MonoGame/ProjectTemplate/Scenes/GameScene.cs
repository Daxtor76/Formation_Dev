using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ProjectTemplate.Scenes;

namespace ProjectTemplate
{
    class GameScene : Scene
    {
        public GameScene(MainGame pProjectGame, string pName) : base(pProjectGame, pName)
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
