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
using System.Diagnostics;

namespace Soutenance_MonoGame
{
    public class Mover
    {
        public Vector2 direction;
        public float speed;
        public Vector2 accel;

        public Mover()
        {
            
        }

        public Mover(float pSpeed)
        {
            speed = pSpeed;
            direction = new Vector2();
            accel = Vector2.Zero;
        }

        public void Move(GameTime gameTime, Entity entity, Vector2 direction, Vector2 targetAccel)
        {
            ManageAccel(gameTime, targetAccel);

            Vector2 screenSize = Utils.GetScreenSize();
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;

            entity.position.X = Math.Clamp(entity.position.X + accel.X * speed * direction.X * dt, 0.0f, screenSize.X - entity.size.X);
            entity.position.Y = Math.Clamp(entity.position.Y + accel.Y * speed * direction.Y * dt, 0.0f, screenSize.Y - entity.size.Y);
            accel *= 0.9f;
        }

        public void MoveSmoothly(GameTime gameTime, Entity entity)
        {
            Vector2 screenSize = Utils.GetScreenSize();
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;

            entity.position.X = Math.Clamp(entity.position.X + accel.X * speed * dt, 0.0f, screenSize.X - entity.size.X);
            entity.position.Y = Math.Clamp(entity.position.Y + accel.Y * speed * dt, 0.0f, screenSize.Y - entity.size.Y);
            accel *= 0.9f;
        }

        public void MoveTo(GameTime gameTime, Entity entity, Vector2 destination, Vector2 targetAccel)
        {
            direction = destination - entity.position;
            Move(gameTime, entity, direction, targetAccel);
        }

        public void FollowAbove(Entity entity, Entity target)
        {
            entity.position.X = target.position.X + target.size.X * 0.5f - entity.size.X * 0.5f;
            entity.position.Y = target.position.Y - target.size.Y * 0.5f - entity.size.Y * 0.5f;
        }

        public void FollowCenter(Entity entity, Entity target)
        {
            entity.position.X = target.position.X + target.size.X * 0.5f - entity.size.X * 0.5f;
            entity.position.Y = target.position.Y + target.size.Y * 0.5f - entity.size.Y * 0.5f;
        }

        public void Follow(Entity entity, Entity target, Vector2 offset)
        {
            entity.position = target.GetCenterPosition() - entity.size * 0.5f * entity.scale + offset;
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

        public void Launch(Vector2 pDirection, Vector2 pAccel)
        {
            accel = pAccel;
            direction = pDirection;
        }
    }
}
