using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using Vector2 = System.Numerics.Vector2;
using Soutenance_MonoGame;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;

namespace Soutenance_MonoGame
{
    public class Mover
    {
        public Vector2 direction;
        public float speed;
        Vector2 targetPos;
        float accel;

        public Mover(Vector2 pPosition, float pSpeed)
        {
            targetPos = pPosition;
            speed = pSpeed;
            direction = new Vector2();
            accel = 0.0f;
        }

        public Vector2 Move(GameTime gameTime, Vector2 position, Vector2 size, Vector2 direction)
        {
            Vector2 screenSize = Utils.GetScreenSize();
            position += speed * direction * (float)gameTime.ElapsedGameTime.TotalSeconds;
            return new Vector2(Math.Clamp(position.X, 0, screenSize.X - size.X), position.Y);
        }

        public Vector2 MoveSmoothly(GameTime gameTime, Vector2 position, Vector2 size)
        {
            Vector2 screenSize = Utils.GetScreenSize();
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;

            position.X += accel * speed * dt;
            accel *= 0.9f;

            return new Vector2(Math.Clamp(position.X, 0, screenSize.X - size.X), position.Y);
        }

        public Vector2 Follow(Vector2 size, Entity target)
        {
            Vector2 pos = new Vector2();

            pos.X = target.position.X + target.size.X * 0.5f - size.X * 0.5f;
            pos.Y = target.position.Y - target.size.Y * 0.5f - size.Y * 0.5f;

            return pos;
        }

        public void IncreaseAccel(GameTime gameTime, Vector2 direction)
        {
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;
            Math.Clamp(accel += 10 * direction.X * dt, -100.0f, 100.0f);
        }
    }
}
