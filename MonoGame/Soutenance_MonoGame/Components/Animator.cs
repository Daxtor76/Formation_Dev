using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;
using Vector2 = System.Numerics.Vector2;

namespace Soutenance_MonoGame
{
    public class Animator
    {
        int frame;
        Vector2 size;

        public Dictionary<string, Animation> anims = new Dictionary<string, Animation>();

        public Animator(Vector2 pSize)
        {
            frame = 0;
            size = pSize;
        }

        public Rectangle ReadAnim(GameTime gameTime, string state)
        {
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;
            Animation anim = anims[state];

            anim.currentTimer -= dt;
            if (anim.currentTimer <= 0.0f)
            {
                if (anim.isLoop)
                {
                    frame = (int)anim.frames.X + (frame + 1) % (anim.frameCount + 1);
                }
                else
                {
                    if (frame < anim.frameCount - 1)
                        frame = (int)anim.frames.X + (frame + 1);
                    else
                        anim.isOver = true;
                }
                anim.currentTimer = anim.duration / anim.frameCount;
            }

            return new Rectangle(
            (int)size.X * frame,
            (int)0,
            (int)size.X,
            (int)size.Y);
        }
    }
}
