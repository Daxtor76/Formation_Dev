﻿using Microsoft.Xna.Framework;
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
            foreach (Collider col in colliders)
            {
                col.Update(gameTime);
                foreach (Collider other in colliders)
                {
                    if (col != other)
                    {
                        if (other.enabled && other.active)
                        {
                            if (col.IsColliding(other))
                            {
                                col.others.Add(other);
                            }
                        }
                    }
                }
                col.ApplyCollisions();
                col.others.Clear();
            }
        }

        public void DrawColliders()
        {
            foreach (Collider col in colliders)
            {
                col.Draw();
            }
        }

        public void CleanColliders()
        {
            for (int i = colliders.Count - 1; i >= 0 ; i--)
            {
                Collider col = colliders[i];
                if (!col.parent.enabled || !col.enabled)
                {
                    colliders.Remove(col);
                }
            }
        }
    }
}
