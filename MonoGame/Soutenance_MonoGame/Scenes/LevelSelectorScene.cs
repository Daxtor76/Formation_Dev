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
using Vector2 = System.Numerics.Vector2;

namespace Soutenance_MonoGame
{
    class LevelSelectorScene : Scene
    {
        public LevelSelectorScene(string pName) : base(pName)
        {
        }

        public override void Load()
        {
            base.Load();

            Text text = new Text(new Vector2(100.0f, 100.0f), "Level Selector Scene", "Title", Text.FontType.big, Color.Blue);

            Debug.WriteLine($"{name} scene has been loaded.");
        }

        private void OnPlayButtonClick()
        {
            Debug.WriteLine("loading");
            ServiceLocator.GetService<ISceneManager>().SetCurrentScene(typeof(GameScene));
            ServiceLocator.GetService<ILevelManager>().ChangeLevel(1);
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
