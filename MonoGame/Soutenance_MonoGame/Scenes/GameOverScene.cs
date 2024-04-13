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
            Vector2 screenCenter = Utils.GetScreenCenter();
            ISaveManager saveManager = ServiceLocator.GetService<ISaveManager>();
            new Text(new Vector2(screenCenter.X, screenCenter.Y - 200.0f), $"{(saveManager.GetInt("life") > 0 ? "Victory!" : "Defeat :(")}", "textVictory", Text.FontType.big, saveManager.GetInt("life") > 0 ? Color.Green : Color.Red);

            new Text(new Vector2(screenCenter.X, screenCenter.Y), $"Remaining lives: {saveManager.GetInt("life")}", "textLives", Text.FontType.normal, Color.Blue);
            new Text(new Vector2(screenCenter.X, screenCenter.Y + 50.0f), $"Total Bounces: {saveManager.GetInt("bounces")}", "textBounces", Text.FontType.normal, Color.Blue);
            new Text(new Vector2(screenCenter.X, screenCenter.Y + 100.0f), $"Total Duration: {MathF.Round(saveManager.GetFloat("gameDuration"), 0)}s", "textDuration", Text.FontType.normal, Color.Blue);

            new Button(new Vector2(screenCenter.X - 225.0f, screenCenter.Y + 200.0f), Button.Colors.blue, "button_reload", "Reload", Text.FontType.normal, Color.Red, OnReloadButtonClick);
            if (ServiceLocator.GetService<ILevelManager>().GetLevel(ServiceLocator.GetService<ISaveManager>().GetInt("lastLevelPlayed") + 1) != null)
                new Button(new Vector2(screenCenter.X, screenCenter.Y + 200.0f), Button.Colors.green, "button_next", "Next Level", Text.FontType.normal, Color.Red, OnNextLevelButtonClick);
            new Button(new Vector2(screenCenter.X + 225.0f, screenCenter.Y + 200.0f), Button.Colors.blue, "button_mainMenu", "Main Menu", Text.FontType.normal, Color.Red, OnMainMenuButtonClick);

            base.Load();
            Debug.WriteLine($"{name} scene has been loaded.");
        }

        private void OnMainMenuButtonClick(int i)
        {
            ServiceLocator.GetService<ISceneManager>().SetCurrentScene(typeof(MenuScene));
        }

        private void OnNextLevelButtonClick(int i)
        {
            ServiceLocator.GetService<ISceneManager>().SetCurrentScene(typeof(GameScene));
            ServiceLocator.GetService<ILevelManager>().ChangeLevel(ServiceLocator.GetService<ISaveManager>().GetInt("lastLevelPlayed") + 1);
        }

        private void OnReloadButtonClick(int i)
        {
            ServiceLocator.GetService<ISceneManager>().SetCurrentScene(typeof(GameScene));
            ServiceLocator.GetService<ILevelManager>().ChangeLevel(ServiceLocator.GetService<ISaveManager>().GetInt("lastLevelPlayed"));
        }
    }
}
