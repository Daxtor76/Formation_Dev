using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Soutenance_MonoGame.Controllers;
using Soutenance_MonoGame.Interfaces;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame.Constructors
{
    public class Collider : Entity
    {
        public Entity parent {get; private set;}
        public delegate void CallBack(Collider other);
        CallBack collisionEffect;
        CallBack continuousCollisionEffect;

        Texture2D texture;
        Rectangle rect;

        bool canCollide = true;

        public Collider(Entity pParent, CallBack pCollisionEffect = null, CallBack pContinuousCollisionEffect = null)
        {
            parent = pParent;
            Position = pParent.Position;
            size = pParent.size;
            collisionEffect = pCollisionEffect;
            continuousCollisionEffect = pContinuousCollisionEffect;

            texture = new Texture2D(MainGame._graphics.GraphicsDevice, 1, 1);
            texture.SetData(new[] { Color.Green });

            rect = new Rectangle((int)Position.X, (int)Position.Y, (int)size.X, (int)size.Y);

            CollisionController.collidersList.Add(this);
        }

        public override void Update()
        {
            if (parent != null)
            {
                Position = parent.Position - size * 0.5f;
                rect.X = (int)Position.X;
                rect.Y = (int)Position.Y;
            }
        }

        public override void Draw()
        {
            if (MainGame.debugMode)
                MainGame._spriteBatch.Draw(texture, rect, new Color(Color.Green, 100));
        }

        public void CheckCollision(Collider other)
        {
            if (other.parent is ICollidable)
            {
                if (collisionEffect != null)
                {
                    if (IsColliding(other) && canCollide)
                    {
                        canCollide = false;
                        collisionEffect(other);
                    }
                }

                if (continuousCollisionEffect != null)
                {
                    if (IsColliding(other))
                    {
                        continuousCollisionEffect(other);
                    }
                }
            }
        }

        public bool IsColliding(Collider other)
        {
            if (Position.X < other.Position.X + other.size.X &&
                Position.X + size.X > other.Position.X &&
                Position.Y < other.Position.Y + other.size.Y &&
                Position.Y + size.Y > other.Position.Y)
            {
                return true;
            }
            canCollide = true;
            return false;
        }
    }
}
