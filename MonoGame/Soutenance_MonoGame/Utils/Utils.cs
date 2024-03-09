using Microsoft.Xna.Framework.Graphics;
using Soutenance_MonoGame;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public static class Utils
    {
        public static Vector2 GetScreenSize()
        {
            Vector2 screenSize = new Vector2();

            screenSize.X = MainGame._graphics.PreferredBackBufferWidth;
            screenSize.Y = MainGame._graphics.PreferredBackBufferHeight;

            return screenSize;
        }
        public static Vector2 GetScreenCenter()
        {
            Vector2 screenSize = new Vector2();

            screenSize.X = MainGame._graphics.PreferredBackBufferWidth * 0.5f;
            screenSize.Y = MainGame._graphics.PreferredBackBufferHeight * 0.5f;

            return screenSize;
        }
        public static Vector2 GetPaddleSpawnPosition()
        {
            Vector2 paddleSpawnPos = new Vector2();

            paddleSpawnPos.X = MainGame._graphics.PreferredBackBufferWidth * 0.5f;
            paddleSpawnPos.Y = MainGame._graphics.PreferredBackBufferHeight - MainGame._graphics.PreferredBackBufferHeight * 0.05f;

            return paddleSpawnPos;
        }
    }
}
