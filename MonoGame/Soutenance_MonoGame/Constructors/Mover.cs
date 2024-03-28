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

        public void Move(GameTime gameTime, Entity entity, Vector2 direction)
        {
            Vector2 screenSize = Utils.GetScreenSize();
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;

            entity.position += accel * speed * direction * dt;
            accel *= 0.9f;

            Math.Clamp(entity.position.X, 0.0f, screenSize.X - entity.size.X);
            Math.Clamp(entity.position.Y, 0.0f, screenSize.Y - entity.size.Y);
        }

        public void MoveSmoothly(GameTime gameTime, Entity entity)
        {
            Vector2 screenSize = Utils.GetScreenSize();
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;

            entity.position += accel * speed * dt;
            accel *= 0.9f;

            Math.Clamp(entity.position.X, 0.0f, screenSize.X - entity.size.X);
            Math.Clamp(entity.position.Y, 0.0f, screenSize.Y - entity.size.Y);
        }

        public void FollowAbove(Entity entity, Entity target)
        {
            entity.position.X = target.position.X + target.size.X * 0.5f - entity.size.X * 0.5f;
            entity.position.Y = target.position.Y - target.size.Y * 0.5f - entity.size.Y * 0.5f;
        }

        public void ManageAccel(GameTime gameTime, Vector2 targetAccel)
        {
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;
            if (accel.X > targetAccel.X)
                Math.Clamp(accel.X -= 10 * dt, 0.0f, 15.0f);
            else
                Math.Clamp(accel.X += 10 * dt, 0.0f, 15.0f);

            if (accel.Y > targetAccel.Y)
                Math.Clamp(accel.Y -= 10 * dt, 0.0f, 15.0f);
            else
                Math.Clamp(accel.Y += 10 * dt, 0.0f, 15.0f);
        }

        public void IncreaseAccelByDirection(GameTime gameTime, Vector2 direction)
        {
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;
            Math.Clamp(accel.X += 10 * direction.X * dt, -100.0f, 100.0f);
            Math.Clamp(accel.Y += 10 * direction.Y * dt, -100.0f, 100.0f);
        }
    }
}
