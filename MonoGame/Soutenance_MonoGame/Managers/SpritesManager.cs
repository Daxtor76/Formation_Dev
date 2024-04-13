using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    sealed class SpritesManager : ISpritesManager
    {
        Dictionary<string, Texture2D> paddleTextures = new Dictionary<string, Texture2D>();
        Dictionary<string, Texture2D> ballTextures = new Dictionary<string, Texture2D>();
        Dictionary<string, Texture2D> bricksTextures = new Dictionary<string, Texture2D>();
        Dictionary<string, Texture2D> powerupsTextures = new Dictionary<string, Texture2D>();
        Dictionary<string, Texture2D> googleEyesTextures = new Dictionary<string, Texture2D>();
        Dictionary<string, Texture2D> buttonTextures = new Dictionary<string, Texture2D>();

        Texture2D portalTexture;

        public SpritesManager()
        {
            paddleTextures = LoadFromFolder("Paddle");
            ballTextures = LoadFromFolder("Balls");
            bricksTextures = LoadFromFolder("Bricks");
            powerupsTextures = LoadFromFolder("PowerUps");
            googleEyesTextures = LoadFromFolder("FXs/GooglyEyes");
            buttonTextures = LoadFromFolder("UI/Buttons");

            portalTexture = MainGame.content.Load<Texture2D>($"Teleporter/portal_spritesheet");

            ServiceLocator.RegisterService<ISpritesManager>(this);
        }

        public Dictionary<string, Texture2D> LoadFromFolder(string folderName)
        {
            Dictionary<string, Texture2D> list = new Dictionary<string, Texture2D>();
            char sep = Path.DirectorySeparatorChar;
            string dirPath = MainGame.content.RootDirectory + sep + folderName;

            if (Directory.Exists(dirPath))
            {
                foreach (string filePath in Directory.GetFiles(dirPath))
                {
                    string[] splitPath = filePath.Split(sep, '.');
                    string assetName = splitPath[2];
                    string directoryName = Directory.GetParent(filePath).ToString() + sep;

                    list.Add(assetName, MainGame.content.Load<Texture2D>($"{directoryName + assetName}"));
                }
            }
            else
                Debug.WriteLine($"The folder {folderName} does not exist.");

            return list;
        }

        public Texture2D GetPortalTexture()
        {
            return portalTexture;
        }

        public Texture2D GetPowerUpTexture(string textureName)
        {
            Random r = new Random();
            return powerupsTextures[textureName] != null ? powerupsTextures[textureName] : powerupsTextures.ElementAt(r.Next(0, powerupsTextures.Count)).Value;
        }

        public Texture2D GetPaddleTexture(string textureName)
        {
            Random r = new Random();
            return paddleTextures[textureName] != null ? paddleTextures[textureName] : paddleTextures.ElementAt(r.Next(0, paddleTextures.Count)).Value;
        }

        public Texture2D GetBallTexture(string textureName)
        {
            Random r = new Random();
            return ballTextures[textureName] != null ? ballTextures[textureName] : ballTextures.ElementAt(r.Next(0, ballTextures.Count)).Value;
        }

        public Texture2D GetBrickTexture(string textureName)
        {
            Random r = new Random();
            return bricksTextures[textureName] != null ? bricksTextures[textureName] : bricksTextures.ElementAt(r.Next(0, bricksTextures.Count)).Value;
        }

        public Texture2D GetGooglyEyesTexture(string textureName)
        {
            Random r = new Random();
            return googleEyesTextures[textureName] != null ? googleEyesTextures[textureName] : googleEyesTextures.ElementAt(r.Next(0, googleEyesTextures.Count)).Value;
        }

        public Texture2D GetButtonTexture(string textureName)
        {
            Random r = new Random();
            return buttonTextures[textureName] != null ? buttonTextures[textureName] : buttonTextures.ElementAt(r.Next(0, buttonTextures.Count)).Value;
        }
    }
}
