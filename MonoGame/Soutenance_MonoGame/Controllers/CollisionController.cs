using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public static class CollisionController
    {
        public static List<Collider> colliders = new List<Collider>();

        public static void UpdateColliders()
        {
            foreach (Collider col in colliders)
            {
                col.Update();
                foreach (Collider other in colliders)
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
            foreach (Collider col in colliders)
            {
                col.Draw();
            }
        }

        public static void CleanColliders()
        {
            for (int i = colliders.Count - 1; i >= 0; i--)
            {
                if (!colliders[i].parent.enabled)
                    colliders.Remove(colliders[i]);
            }
        }
    }
}
