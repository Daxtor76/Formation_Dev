using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using Soutenance_MonoGame.Interfaces;
using Soutenance_MonoGame;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame.Constructors
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
            
            Position += speed * direction * (float)gameTime.ElapsedGameTime.TotalSeconds;
            Position = new Vector2(Math.Clamp(Position.X, 0, screenSize.X - size.X), Math.Clamp(Position.Y, 0, screenSize.Y - size.Y));
        }

        protected Vector2 GetInputDirection()
        {
            Vector2 direction = new Vector2();

            if (Keyboard.GetState().IsKeyDown(Keys.D))
                direction.X = 1;
            else if (Keyboard.GetState().IsKeyDown(Keys.Q))
                direction.X = -1;

            /*
            if (Keyboard.GetState().IsKeyDown(Keys.Z))
                direction.Y = -1;
            else if (Keyboard.GetState().IsKeyDown(Keys.S))
                direction.Y = 1;
            */
            return direction;
        }
    }
}
