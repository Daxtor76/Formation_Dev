using Microsoft.Xna.Framework.Graphics;
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

            screenSize.X = MainGame.graphics.PreferredBackBufferWidth;
            screenSize.Y = MainGame.graphics.PreferredBackBufferHeight;

            return screenSize;
        }
        public static Vector2 GetScreenCenter()
        {
            Vector2 screenSize = new Vector2();

            screenSize.X = MainGame.graphics.PreferredBackBufferWidth * 0.5f;
            screenSize.Y = MainGame.graphics.PreferredBackBufferHeight * 0.5f;

            return screenSize;
        }
    }
}
