using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class Collider : Entity
    {
        public Entity parent {get; private set;}
        public Vector2 oldPosition;
        public delegate void CallBack(Collider other, string side);
        CallBack collisionEffect;
        CallBack continuousCollisionEffect;

        Texture2D texture;
        Rectangle rect;

        bool canCollide = true;

        public Collider(Entity pParent, CallBack pCollisionEffect = null, CallBack pContinuousCollisionEffect = null)
        {
            parent = pParent;
            size = pParent.size;
            position = new Vector2(pParent.position.X + size.X, pParent.position.Y);
            collisionEffect = pCollisionEffect;
            continuousCollisionEffect = pContinuousCollisionEffect;

            texture = new Texture2D(MainGame._graphics.GraphicsDevice, 1, 1);
            texture.SetData(new[] { Color.Green });

            rect = new Rectangle((int)position.X, (int)position.Y, (int)size.X, (int)size.Y);

            CollisionController.colliders.Add(this);
        }

        public override void Update()
        {
            if (parent != null)
            {
                position = parent.position;
                rect.X = (int)position.X;
                rect.Y = (int)position.Y;
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
                    if (IsColliding(other, out string collidingSide) && canCollide)
                    {
                        canCollide = false;
                        collisionEffect(other, collidingSide);
                    }
                }

                if (continuousCollisionEffect != null)
                {
                    if (IsColliding(other, out string collidingSide))
                    {
                        continuousCollisionEffect(other, collidingSide);
                    }
                }
            }
        }

        public bool IsColliding(Collider other, out string collidingSide)
        {
            collidingSide = "";

            if (position.X < other.position.X + other.size.X &&
                position.X + size.X > other.position.X &&
                position.Y < other.position.Y + other.size.Y &&
                position.Y + size.Y > other.position.Y)
            {
                if (oldPosition.X + size.X <= other.position.X)
                {
                    collidingSide = "right";
                }
                if (oldPosition.X >= other.position.X + other.size.X)
                {
                    collidingSide = "left";
                }
                if (oldPosition.Y >= other.position.Y + other.size.Y)
                {
                    collidingSide = "top";
                }
                if (oldPosition.Y + size.Y <= other.position.Y)
                {
                    collidingSide = "bottom";
                }
                return true;
            }

            canCollide = true;
            return false;
        }
    }
}
