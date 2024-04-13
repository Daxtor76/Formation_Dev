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
            Text textVictory = new Text(new Vector2(screenCenter.X, screenCenter.Y - 200.0f), $"{(saveManager.GetInt("life") > 0 ? "Victory!" : "Defeat :(")}", "textVictory", Text.FontType.big, saveManager.GetInt("life") > 0 ? Color.Green : Color.Red);

            Text textLives = new Text(new Vector2(screenCenter.X, screenCenter.Y), $"Remaining lives: {saveManager.GetInt("life")}", "textLives", Text.FontType.normal, Color.Blue);
            Text textBounces = new Text(new Vector2(screenCenter.X, screenCenter.Y + 50.0f), $"Total Bounces: {saveManager.GetInt("bounces")}", "textBounces", Text.FontType.normal, Color.Blue);
            Text textDuration = new Text(new Vector2(screenCenter.X, screenCenter.Y + 100.0f), $"Total Duration: {MathF.Round(saveManager.GetFloat("gameDuration"), 0)}s", "textDuration", Text.FontType.normal, Color.Blue);

            base.Load();
            Debug.WriteLine($"{name} scene has been loaded.");
        }

        public void GetGameData()
        {
                    
        }
    }
}
