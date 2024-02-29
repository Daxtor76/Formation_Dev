using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Scenes
{
    public abstract class Scene
    {
        public string name;
        public Scene(string pName)
        {
            name = pName;
        }

        public virtual void Load()
        {
        }

        public virtual void Update(GameTime gameTime)
        {
        }

        public virtual void Draw(GameTime gameTime)
        {
        }

        public virtual void Unload()
        {
        }
    }
}
