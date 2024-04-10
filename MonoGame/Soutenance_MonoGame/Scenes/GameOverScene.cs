using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Vector2 = System.Numerics.Vector2;

namespace Soutenance_MonoGame
{
    class GameOverScene : Scene
    {
        public GameOverScene(string pName) : base(pName)
        {
        }

        public override void Load()
        {
            Text text = new Text(new Vector2(100.0f, 100.0f), "Game Over Scene", "Title", Text.FontType.big, Color.Blue);

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
