using Microsoft.Xna.Framework;
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
            Debug.WriteLine($"New {name} scene");
        }

        public override void Load()
        {
            base.Load();
            Debug.WriteLine($"{name} scene LOAD");
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            Debug.WriteLine($"{name} scene UPDATE");
        }

        public override void Draw(GameTime gameTime)
        {
            base.Draw(gameTime);
            Debug.WriteLine($"{name} scene DRAW");
        }

        public override void Unload()
        {
            base.Unload();
            Debug.WriteLine($"{name} scene UNLOAD");
        }
    }
}
