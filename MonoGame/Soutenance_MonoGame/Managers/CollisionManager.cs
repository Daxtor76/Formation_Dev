using Microsoft.Xna.Framework;
using Soutenance_MonoGame.Interfaces;
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
        Dictionary<Entity, Collider> colliders = new Dictionary<Entity, Collider>();

        public CollisionManager()
        {
            ServiceLocator.RegisterService<ICollisionManager>(this);
        }

        public void AddCollider(Collider col)
        {
            colliders.Add(col.parent, col);
        }

        public Collider GetCollider(Entity entity)
        {
            return colliders[entity];
        }

        public void UpdateColliders()
        {
            foreach (Collider col in colliders.Values)
            {
                col.Update();
                foreach (Collider other in colliders.Values)
                {
                    if (col != other)
                    {
                        col.CheckCollision(other);
                    }
                }
            }
        }

        public void DrawColliders()
        {
            foreach (Collider col in colliders.Values)
            {
                col.Draw();
            }
        }

        public void CleanColliders()
        {
            foreach (KeyValuePair<Entity, Collider> kvp in colliders)
            {
                if (!kvp.Value.parent.enabled)
                {
                    colliders.Remove(kvp.Key);
                }
            }
        }
    }
}
