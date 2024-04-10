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
    class MenuScene : Scene
    {
        public MenuScene(string pName) : base(pName)
        {
        }

        public override void Load()
        {
            base.Load();

            Button button = new Button(new Vector2(500.0f, 500.0f), Button.Colors.blue, "button1", "Play", Text.FontType.normal, Color.Red, OnSelectLevelButtonClick);
            //Button button2 = new Button(new Vector2(1000.0f, 100.0f), Button.Colors.green, "button2", OnSelectLevelButtonClick);

            Text text = new Text(new Vector2(100.0f, 100.0f), "Test", "text1", Text.FontType.big, Color.Blue);

            Debug.WriteLine($"{name} scene has been loaded.");
        }

        private void OnSelectLevelButtonClick()
        {
            Debug.WriteLine("GO TO SELECT LEVEL SCREEN");
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
