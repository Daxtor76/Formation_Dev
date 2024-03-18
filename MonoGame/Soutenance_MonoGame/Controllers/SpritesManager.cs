using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    class SpritesManager : ISpritesManager
    {
        List<Texture2D> paddleTextures;
        List<Texture2D> ballTextures;

        public SpritesManager()
        {
            paddleTextures = LoadPaddleTextures();
            ballTextures = LoadBallTextures();

            ServiceLocator.RegisterService<ISpritesManager>(this);
        }

        public List<Texture2D> LoadPaddleTextures()
        {
            List<Texture2D> list = new List<Texture2D>();
            string dirPath = MainGame._content.RootDirectory + "/Paddle";

            foreach (string filePath in System.IO.Directory.GetFiles(dirPath))
            {
                string path = filePath.Split('/', '.')[1];
                list.Add(MainGame._content.Load<Texture2D>($"{path}"));
            }

            return list;
        }

        public List<Texture2D> LoadBallTextures()
        {
            List<Texture2D> list = new List<Texture2D>();
            string dirPath = MainGame._content.RootDirectory + "/Balls";

            foreach (string filePath in System.IO.Directory.GetFiles(dirPath))
            {
                string path = filePath.Split('/', '.')[1];
                list.Add(MainGame._content.Load<Texture2D>($"{path}"));
            }

            return list;
        }

        public Texture2D GetPaddleTexture(int id)
        {
            return paddleTextures[id] != null ? paddleTextures[id] : paddleTextures[0];
        }

        public Texture2D GetBallTexture(int id)
        {
            return ballTextures[id] != null ? ballTextures[id] : ballTextures[0];
        }
    }
}
