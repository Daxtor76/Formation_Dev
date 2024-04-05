using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class Animation
    {
        public Vector2 frames;
        public int frameCount;
        public float duration;
        public bool isLoop;
        public bool isOver;
        public float currentTimer;

        public Animation(int pFrom, int pTo, float pDuration, bool pIsLoop)
        {
            frames = new Vector2(pFrom, pTo);
            frameCount = pTo - pFrom;
            duration = pDuration;
            isLoop = pIsLoop;
            currentTimer = pDuration / frameCount;
        }
    }
}
