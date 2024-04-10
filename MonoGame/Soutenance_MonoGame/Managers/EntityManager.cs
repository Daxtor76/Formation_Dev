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
        public EntityManager()
        {
            ServiceLocator.RegisterService<IEntityManager>(this);
        }

        public void AddEntity(IEntity entity)
        {
            ServiceLocator.GetService<ISceneManager>().GetCurrentScene().entities.Add(entity.GetName(), entity);
        }

        public IEntity GetEntity(string name)
        {
            return ServiceLocator.GetService<ISceneManager>().GetCurrentScene().entities[name];
        }

        public List<T> GetEntitiesOfType<T>()
        {
            List<T> list = new List<T>();

            foreach (IEntity entity in ServiceLocator.GetService<ISceneManager>().GetCurrentScene().entities.Values)
            {
                if (entity.GetType() == typeof(T))
                    list.Add((T)entity);
            }

            return list;
        }

        public void UpdateEntities(GameTime gameTime)
        {
            foreach (IEntity entity in ServiceLocator.GetService<ISceneManager>().GetCurrentScene().entities.Values)
            {
                if (entity.IsEnabled() && entity.IsActive())
                    entity.Update(gameTime);
            }
        }

        public void DrawEntities()
        {
            foreach (IEntity entity in ServiceLocator.GetService<ISceneManager>().GetCurrentScene().entities.Values)
            {
                if (entity.IsEnabled() && entity.IsActive())
                    entity.Draw();
            }
        }

        public void UnloadEntities()
        {
            foreach (IEntity entity in ServiceLocator.GetService<ISceneManager>().GetCurrentScene().entities.Values)
            {
                entity.Unload();
            }
        }

        public void CleanEntities()
        {
            foreach (KeyValuePair<string, IEntity> kvp in ServiceLocator.GetService<ISceneManager>().GetCurrentScene().entities)
            {
                if (!kvp.Value.IsEnabled())
                {
                    ServiceLocator.GetService<ISceneManager>().GetCurrentScene().entities.Remove(kvp.Key);
                }
            }
        }
    }
}
