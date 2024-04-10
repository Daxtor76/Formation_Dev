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

            Button playButton = new Button(new Vector2(300.0f, 500.0f), Button.Colors.blue, "button1", "Play", Text.FontType.normal, Color.Red, OnPlayButtonClick);
            Button levelEditorButton = new Button(new Vector2(700.0f, 200.0f), Button.Colors.green, "button2", "Level editor", Text.FontType.normal, Color.Red, OnLevelEditorButtonClick);

            Text text = new Text(new Vector2(100.0f, 100.0f), "Menu Scene", "Title", Text.FontType.big, Color.Blue);

            Debug.WriteLine($"{name} scene has been loaded.");
        }

        private void OnPlayButtonClick()
        {
            ServiceLocator.GetService<ISceneManager>().SetCurrentScene(typeof(LevelSelectorScene));
        }

        private void OnLevelEditorButtonClick()
        {
            Debug.WriteLine("Plus qu'à faire un level editor, c'est rapide tkt");
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
