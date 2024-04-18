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

            ServiceLocator.GetService<ILevelManager>().LoadLevels();

            Vector2 screenCenter = Utils.GetScreenCenter();

            new Text(new Vector2(screenCenter.X, screenCenter.Y - 200.0f), "Menu Scene", "Title", Text.FontType.big, Color.Blue);
            new Button(new Vector2(screenCenter.X - 250.0f, screenCenter.Y + 100.0f), Button.Colors.blue, "button_1", "Play", Text.FontType.normal, Color.Red, OnPlayButtonClick);
            new Button(new Vector2(screenCenter.X + 175.0f, screenCenter.Y + 100.0f), Button.Colors.green, "button_2", "Level editor", Text.FontType.normal, Color.Red, OnLevelEditorButtonClick);

            Debug.WriteLine($"{name} scene has been loaded.");
        }

        private void OnPlayButtonClick(int i)
        {
            ServiceLocator.GetService<ISceneManager>().SetCurrentScene(typeof(LevelSelectorScene));
        }

        private void OnLevelEditorButtonClick(int i)
        {
            ServiceLocator.GetService<ISceneManager>().SetCurrentScene(typeof(LevelEditorScene));
        }
    }
}
