using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    sealed class EntityManager : IEntityManager
    {
        Dictionary<string, IEntity> entities = new Dictionary<string, IEntity>();

        public EntityManager()
        {
            ServiceLocator.RegisterService<IEntityManager>(this);
        }

        public void AddEntity(IEntity entity)
        {
            entities.Add(entity.GetName(), entity);
        }

        public IEntity GetEntity(string name)
        {
            return entities[name];
        }

        public List<T> GetEntitiesOfType<T>()
        {
            List<T> list = new List<T>();

            foreach (IEntity entity in entities.Values)
            {
                if (entity.GetType() == typeof(T))
                    list.Add((T)entity);
            }

            return list;
        }

        public void UpdateEntities(GameTime gameTime)
        {
            foreach(Entity entity in entities.Values)
            {
                if (entity.IsEnabled() && entity.IsActive())
                    entity.Update(gameTime);
            }
        }

        public void DrawEntities()
        {
            foreach(Entity entity in entities.Values)
            {
                if (entity.IsEnabled() && entity.IsActive())
                    entity.Draw();
            }
        }

        public void UnloadEntities()
        {
            foreach (IEntity entity in entities.Values)
            {
                entity.Unload();
            }
        }

        public void CleanEntities()
        {
            foreach (KeyValuePair<string, IEntity> kvp in entities)
            {
                if (!kvp.Value.IsEnabled())
                {
                    entities.Remove(kvp.Key);
                }
            }
        }
    }
}
