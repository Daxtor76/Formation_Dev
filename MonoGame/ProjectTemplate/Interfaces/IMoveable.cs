using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Interfaces
{
    public interface IMoveable
    {
        public abstract void Move(GameTime gameTime, Vector2 direction);
    }
}
