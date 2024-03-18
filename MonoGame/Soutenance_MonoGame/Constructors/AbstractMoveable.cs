using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using Vector2 = System.Numerics.Vector2;
using Soutenance_MonoGame;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public abstract class AbstractMoveable : Entity, IMoveable
    {
        protected float speed = 0.0f;
        protected Vector2 direction;

        public AbstractMoveable(float pSpeed, Vector2 pDirection = new Vector2())
        {
            speed = pSpeed;
            direction = pDirection;
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            Move(gameTime);
        }

        public void Move(GameTime gameTime)
        {
            Vector2 screenSize = Utils.GetScreenSize();
            position += speed * direction * (float)gameTime.ElapsedGameTime.TotalSeconds;
            position = new Vector2(Math.Clamp(position.X, 0, screenSize.X - size.X), position.Y);
        } 
    }
}
