using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame.Interfaces
{
    public interface IEntityManager
    {
        public void AddEntity(Entity entity);
        public Entity GetEntity(string name);
        public void UpdateEntities(GameTime gameTime);
        public void DrawEntities();
        public void CleanEntities();
    }
}
