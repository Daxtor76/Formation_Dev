using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public interface IInputManager
    {
        public Vector2 GetInputDirection();
        public bool KeyDown(Keys key);
        public bool KeyPressed(Keys key);
    }
}
