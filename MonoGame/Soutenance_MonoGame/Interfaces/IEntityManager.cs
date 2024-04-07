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
        public void AddEntity(IEntity entity);
        public List<T> GetEntitiesOfType<T>();
        public IEntity GetEntity(string name);
        public void UpdateEntities(GameTime gameTime);
        public void DrawEntities();
        public void UnloadEntities();
        public void CleanEntities();
    }
}
