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
using System.Xml.Linq;

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

            Vector2 screenCenter = Utils.GetScreenCenter();
            int levelCount = ServiceLocator.GetService<ILevelManager>().GetLevels().Count;
            float buttonGridSizeX = levelCount * 200.0f;

            Text text = new Text(new Vector2(screenCenter.X, screenCenter.Y - 200.0f), "Level Selector Scene", "Title", Text.FontType.big, Color.Blue);

            for (int i = 0; i < levelCount; i ++)
            {
                Vector2 pos = new Vector2(screenCenter.X - buttonGridSizeX * 0.5f + 220.0f * i + 40.0f, screenCenter.Y + 100.0f);
                Button button = new Button(pos, Button.Colors.blue, "button_" + i, "Level " + (i + 1), Text.FontType.normal, Color.Red, OnLevelButtonClick);
            }

            Debug.WriteLine($"{name} scene has been loaded.");
        }

        private void OnLevelButtonClick(int levelId)
        {
            ServiceLocator.GetService<ISceneManager>().SetCurrentScene(typeof(GameScene));
            ServiceLocator.GetService<ILevelManager>().ChangeLevel(levelId);
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
