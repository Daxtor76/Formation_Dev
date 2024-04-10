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
        public string name;

        public Dictionary<string, IEntity> entities = new Dictionary<string, IEntity>();

        public Scene(string pName)
        {
            name = pName;
        }

        public virtual void Load()
        {
        }

        public virtual void Update(GameTime gameTime)
        {
            ServiceLocator.GetService<IEntityManager>().UpdateEntities(gameTime);
            ServiceLocator.GetService<ICollisionManager>().UpdateColliders(gameTime);

            ServiceLocator.GetService<ICollisionManager>().CleanColliders();
            ServiceLocator.GetService<IEntityManager>().CleanEntities();
        }

        public virtual void Draw()
        {
            ServiceLocator.GetService<IEntityManager>().DrawEntities();
            ServiceLocator.GetService<ICollisionManager>().DrawColliders();
        }

        public virtual void Unload()
        {
            ServiceLocator.GetService<IEntityManager>().UnloadEntities();
            ServiceLocator.GetService<ICollisionManager>().CleanColliders();

            ServiceLocator.GetService<IEntityManager>().CleanEntities();
            ServiceLocator.GetService<ICollisionManager>().CleanColliders();
        }
    }
}
