using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public interface IMoveable
    {
        public abstract void Move(GameTime gameTime);
    }
}
