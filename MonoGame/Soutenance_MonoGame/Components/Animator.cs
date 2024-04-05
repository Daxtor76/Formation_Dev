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
                    //self.frame = (self.frame + 1)%animation.framesCount;
                    frame = (frame + 1) % (anim.frameCount + 1);
                }
                else
                {
                    /*if self.frame < animation.framesCount - 1 then
                 self.frame = self.frame + 1;
             else
                         animation.isOver = true;
                     end*/
                }

                anim.currentTimer = anim.duration / anim.frameCount;
            }

            return new Rectangle(
            (int)size.X * frame,
            (int)0,
            (int)size.X,
            (int)size.Y);
        }

        /*
         * 

function _Entity:GetCurrentQuadToDisplay(animation)
    return love.graphics.newQuad((animation.size.x * animation.frames.x) + (animation.size.x * self.frame), 0, animation.size.x, animation.size.y, self.spritesheet);
end

function _Entity:ResetAnim(animation)
    animation:ResetTimer();
    self.frame = 0;
end
         * 
function _Entity:UpdateAnim(deltaTime, animation)
    animation.currentTimer = animation.currentTimer - deltaTime;
    if animation.currentTimer <= 0 then
        if animation.loop then
            self.frame = (self.frame + 1)%animation.framesCount;
        else
            if self.frame < animation.framesCount - 1 then
                self.frame = self.frame + 1;
            else
                animation.isOver = true;
            end
        end
        animation.currentTimer = animation.duration / animation.framesCount;
    end
end*/
    }
}
