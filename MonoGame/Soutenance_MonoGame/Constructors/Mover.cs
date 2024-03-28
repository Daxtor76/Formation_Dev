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
        public Vector2 accel;

        public Mover(float pSpeed)
        {
            speed = pSpeed;
            direction = new Vector2();
            accel = Vector2.Zero;
        }

        public Vector2 Move(GameTime gameTime, Entity entity, Vector2 direction)
        {
            Vector2 screenSize = Utils.GetScreenSize();
            entity.position += accel * speed * direction * (float)gameTime.ElapsedGameTime.TotalSeconds;
            accel *= 0.9f;
            return new Vector2(Math.Clamp(entity.position.X, 0, screenSize.X - entity.size.X), entity.position.Y);
        }

        public Vector2 MoveSmoothly(GameTime gameTime, Entity entity)
        {
            Vector2 screenSize = Utils.GetScreenSize();
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;

            entity.position += accel * speed * dt;
            accel *= 0.9f;

            return new Vector2(Math.Clamp(entity.position.X, 0, screenSize.X - entity.size.X), entity.position.Y);
        }

        public Vector2 FollowAbove(Entity entity, Entity target)
        {
            Vector2 pos = new Vector2();

            pos.X = target.position.X + target.size.X * 0.5f - entity.size.X * 0.5f;
            pos.Y = target.position.Y - target.size.Y * 0.5f - entity.size.Y * 0.5f;

            return pos;
        }

        public void IncreaseAccel(GameTime gameTime)
        {
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;
            Math.Clamp(accel.X += 10 * dt, 0.0f, 100.0f);
            Math.Clamp(accel.Y += 10 * dt, 0.0f, 100.0f);
        }

        public void IncreaseAccel(GameTime gameTime, Vector2 direction)
        {
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;
            Math.Clamp(accel.X += 10 * direction.X * dt, -100.0f, 100.0f);
            Math.Clamp(accel.Y += 10 * direction.Y * dt, -100.0f, 100.0f);
        }
    }
}
