using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate
{
    public abstract class Entity
    {
        public Vector2 position = new Vector2();
        public Vector2 size = new Vector2();
        public Vector2 scale = new Vector2(1, 1);
        public bool enabled = true;
        public string name = "";
        public string layer = "";

        public virtual void Update(GameTime gameTime)
        {
        }

        public virtual void Draw(GameTime gameTime)
        {
        }
    }
}
