using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public interface IEntityManager
    {
        public void AddEntity(Entity entity);
        public List<Entity> GetEntitiesOfType<T>();
        public Entity GetEntity(string name);
        public void StartEntities();
        public void UpdateEntities(GameTime gameTime);
        public void DrawEntities();
        public void CleanEntities();
    }
}
