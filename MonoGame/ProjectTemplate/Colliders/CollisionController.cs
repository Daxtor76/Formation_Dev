using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Colliders
{
    public static class CollisionController
    {
        public static List<Collider> collidersList = new List<Collider>();

        public static void UpdateColliders(GameTime gameTime)
        {
            foreach(Collider col in collidersList)
            {
                col.UpdatePosition(gameTime);
                foreach(Collider other in collidersList)
                {
                    if (col != other)
                    {
                        col.CheckCollision(other);
                    }
                }
            }
        }

        public static void DrawColliders()
        {
            foreach(Collider col in collidersList)
            {
                col.Draw();
            }
        }
    }
}
