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
                if (entity.enabled)
                    entity.Update(gameTime);
            }
        }

        public static void DrawEntities()
        {
            foreach(Entity entity in entities)
            {
                if (entity.enabled)
                    entity.Draw();
            }
        }

        public static void CleanEntities()
        {
            for (int i = entities.Count - 1; i >= 0; i--)
            {
                if (!entities[i].enabled)
                    entities.Remove(entities[i]);
            }
        }
    }
}
