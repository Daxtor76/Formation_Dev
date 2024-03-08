using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using ProjectTemplate.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Constructors
{
    public abstract class AbstractMoveable : Entity, IMoveable
    {
        public AbstractMoveable(MainGame pProjectGame) : base(pProjectGame)
        {
        }


        public void Move(GameTime gameTime, Vector2 direction, float speed)
        {
            position += speed * direction * (float)gameTime.ElapsedGameTime.TotalSeconds;
            position.X = Math.Clamp(position.X, 0, 800 - size.X);
            position.Y = Math.Clamp(position.Y, 0, 500 - size.Y);
        }

        protected Vector2 GetInputDirection()
        {
            Vector2 direction = new Vector2();

            if (Keyboard.GetState().IsKeyDown(Keys.D))
                direction.X = 1;
            else if (Keyboard.GetState().IsKeyDown(Keys.Q))
                direction.X = -1;

            if (Keyboard.GetState().IsKeyDown(Keys.Z))
                direction.Y = -1;
            else if (Keyboard.GetState().IsKeyDown(Keys.S))
                direction.Y = 1;

            return direction;
        }
    }
}
