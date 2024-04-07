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
    class LevelSelectionScene : Scene
    {
        public LevelSelectionScene(string pName) : base(pName)
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
