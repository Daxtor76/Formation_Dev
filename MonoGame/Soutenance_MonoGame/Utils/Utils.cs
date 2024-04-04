using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public static class Utils
    {
        public static float DegreesToRad(float angle)
        {
            return (float)(angle * Math.PI / 180);
        }
        public static float RadToDegrees(float radAngle)
        {
            return (float)(radAngle * 180 / Math.PI);
        }

        public static Vector2 GetDirectionFromAngle(float angle)
        {
            float radAngle = DegreesToRad(angle);

            return new Vector2((float)Math.Cos(radAngle), (float)Math.Sin(radAngle));
        }

        public static Vector2 GetScreenSize()
        {
            Vector2 screenSize = new Vector2();

            screenSize.X = MainGame.graphics.PreferredBackBufferWidth;
            screenSize.Y = MainGame.graphics.PreferredBackBufferHeight;

            return screenSize;
        }
        public static Vector2 GetScreenCenter()
        {
            Vector2 screenCenter = new Vector2();
            Vector2 screenSize = GetScreenSize();

            screenCenter.X = screenSize.X * 0.5f;
            screenCenter.Y = screenSize.Y * 0.5f;

            return screenCenter;
        }
    }
}
