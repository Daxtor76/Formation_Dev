using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Constructors
{
    public class Mover
    {
        public Entity parent;

        public Mover(Entity pParent)
        {
            parent = pParent;
        }

        public void Move(GameTime gameTime, Vector2 direction, float speed)
        {
            parent.position += speed * direction * (float)gameTime.ElapsedGameTime.TotalSeconds;
            parent.position.X = Math.Clamp(parent.position.X, 0, 800 - parent.size.X);
            parent.position.Y = Math.Clamp(parent.position.Y, 0, 500 - parent.size.Y);
        }

        public Vector2 GetInputDirection()
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
