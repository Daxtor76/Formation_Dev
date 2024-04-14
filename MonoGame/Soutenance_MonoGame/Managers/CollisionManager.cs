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
    sealed class CollisionManager : ICollisionManager
    {
        List<Collider> colliders = new List<Collider>();

        public CollisionManager()
        {
            ServiceLocator.RegisterService<ICollisionManager>(this);
        }

        public void AddCollider(Collider col)
        {
            colliders.Add(col);
        }

        public void UpdateColliders(GameTime gameTime)
        {
            for (int i = 0; i < colliders.Count; i++)
            {
                Collider col = colliders[i];
                if (col.IsEnabled() && col.IsActive())
                {
                    col.Update(gameTime);
                    col.others.Clear();
                    for (int y = 0; y < colliders.Count; y++)
                    {
                        Collider other = colliders[y];
                        if (col != other)
                        {
                            if (other.IsEnabled() && other.IsActive())
                            {
                                if (col.IsColliding(other))
                                {
                                    col.others.Add(other);
                                }
                            }
                        }
                    }
                    if (col.others.Count != 0)
                    {
                        col.ApplyCollisions(col.others);
                    }
                    col.StorePreviousOthers();
                }
            }
        }

        public void DrawColliders()
        {
            foreach (Collider col in colliders)
            {
                if (col.IsEnabled() && col.IsActive())
                    col.Draw();
            }
        }

        public void CleanColliders()
        {
            for (int i = colliders.Count - 1; i >= 0 ; i--)
            {
                Collider col = colliders[i];
                if (!col.parent.IsEnabled() || !col.IsEnabled())
                {
                    col.SetEnabled(false);
                    colliders.Remove(col);
                }
            }
        }
    }
}
