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
        Dictionary<string, Entity> entities = new Dictionary<string, Entity>();

        public EntityManager()
        {
            ServiceLocator.RegisterService<IEntityManager>(this);
        }

        public void AddEntity(Entity entity)
        {
            entities.Add(entity.name, entity);
        }

        public Entity GetEntity(string name)
        {
            return entities[name];
        }

        public List<Entity> GetEntitiesOfType<T>()
        {
            List<Entity> list = new List<Entity>();

            foreach (Entity entity in entities.Values)
            {
                if (entity.GetType() == typeof(T))
                    list.Add(entity);
            }

            return list;
        }

        public void UpdateEntities(GameTime gameTime)
        {
            foreach(Entity entity in entities.Values)
            {
                if (entity.enabled)
                    entity.Update(gameTime);
            }
        }

        public void DrawEntities()
        {
            foreach(Entity entity in entities.Values)
            {
                if (entity.enabled)
                    entity.Draw();
            }
        }

        public void CleanEntities()
        {
            foreach (KeyValuePair<string, Entity> kvp in entities)
            {
                if (!kvp.Value.enabled)
                {
                    entities.Remove(kvp.Key);
                }
            }
        }
    }
}
