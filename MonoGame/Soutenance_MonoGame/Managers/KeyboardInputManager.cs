using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class KeyboardInputManager : IInputManager
    {
        bool pressed = false;
        public KeyboardInputManager()
        {
            ServiceLocator.RegisterService<IInputManager>(this);
        }

        public bool IsPressed(Keys key)
        {
            return Keyboard.GetState().IsKeyDown(key);
        }

        public bool IsPressedOnce(Keys key)
        {
            if (!pressed && Keyboard.GetState().IsKeyDown(key))
            {
                pressed = true;
                return true;
            }
            else
            {
                if (Keyboard.GetState().IsKeyUp(key))
                    pressed = false;
                return false;
            }
        }

        public Vector2 GetInputDirection()
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
