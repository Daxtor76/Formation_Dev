using Microsoft.Xna.Framework;
using Soutenance_MonoGame.Constructors;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame.Controllers
{
    public static class CollisionController
    {
        public static List<Collider> collidersList = new List<Collider>();

        public static void UpdateColliders()
        {
            foreach (Collider col in collidersList)
            {
                col.Update();
                foreach (Collider other in collidersList)
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
            foreach (Collider col in collidersList)
            {
                col.Draw();
            }
        }
    }
}
