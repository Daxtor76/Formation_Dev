using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public abstract class Scene
    {
        public enum SceneStates
        {
            Preparation,
            Playing,
            End
        }

        public string name;
        public SceneStates state = SceneStates.Preparation;

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

        public virtual void Draw()
        {
        }

        public virtual void Unload()
        {
        }
    }
}
