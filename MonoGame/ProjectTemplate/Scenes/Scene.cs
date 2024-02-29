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
            Debug.WriteLine($"{name} scene LOAD base");
        }

        public virtual void Update(GameTime gameTime)
        {
            Debug.WriteLine($"{name} scene UPDATE base");
        }

        public virtual void Draw(GameTime gameTime)
        {
            Debug.WriteLine($"{name} scene DRAW base");
        }

        public virtual void Unload()
        {
            Debug.WriteLine($"{name} scene UNLOAD base");
        }
    }
}
