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

        public bool KeyDown(Keys key)
        {
            return Keyboard.GetState().IsKeyDown(key);
        }

        public bool KeyPressed(Keys key)
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

            if (KeyDown(Keys.D))
                direction.X = 1;
            else if (KeyDown(Keys.Q))
                direction.X = -1;

            return direction;
        }
    }
}
