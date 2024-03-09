using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame.Controllers
{
    public static class EntityController
    {
        public static List<Entity> entities = new List<Entity>();
        public static void UpdateEntities(GameTime gameTime)
        {
            foreach(Entity entity in entities)
            {
                entity.Update(gameTime);
            }
        }

        public static void DrawEntities()
        {
            foreach(Entity entity in entities)
            {
                entity.Draw();
            }
        }
    }
}
