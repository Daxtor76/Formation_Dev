using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Diagnostics;
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

        public SpritesManager()
        {
            paddleTextures = LoadFromFolder("Paddle");
            ballTextures = LoadFromFolder("Balls");
            bricksTextures = LoadFromFolder("Bricks");

            ServiceLocator.RegisterService<ISpritesManager>(this);
        }

        public Dictionary<string, Texture2D> LoadFromFolder(string folderName)
        {
            Dictionary<string, Texture2D> list = new Dictionary<string, Texture2D>();
            string dirPath = MainGame.content.RootDirectory + "/" + folderName;

            foreach (string filePath in System.IO.Directory.GetFiles(dirPath))
            {
                string path = filePath.Split('/', '.')[1];
                string assetName = path.Split('\\')[1];
                list.Add(assetName, MainGame.content.Load<Texture2D>($"{path}"));
            }

            return list;
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
    }
}
