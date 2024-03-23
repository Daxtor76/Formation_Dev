using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Soutenance_MonoGame.Interfaces;

namespace Soutenance_MonoGame
{
    public class Collider : Entity
    {
        public Entity parent {get; private set;}
        public Vector2 oldPosition;
        public List<Collider> others = new List<Collider>();
        public delegate void CallBackOthersEffect(Collider other);
        CallBackOthersEffect collisionEnterEffect;
        CallBackOthersEffect continuousCollisionEffect;

        Texture2D texture;
        Rectangle rect;

        bool canCollide = true;

        public Collider(Entity pParent, CallBackOthersEffect pCollisionEffect = null, CallBackOthersEffect pContinuousCollisionEffect = null)
        {
            parent = pParent;
            size = pParent.size;
            position = new Vector2(pParent.position.X + size.X, pParent.position.Y);
            collisionEnterEffect = pCollisionEffect;
            continuousCollisionEffect = pContinuousCollisionEffect;

            texture = new Texture2D(MainGame.graphics.GraphicsDevice, 1, 1);
            texture.SetData(new[] { Color.Green });

            rect = new Rectangle((int)position.X, (int)position.Y, (int)size.X, (int)size.Y);

            ServiceLocator.GetService<ICollisionManager>().AddCollider(this);
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
                MainGame.spriteBatch.Draw(texture, rect, new Color(Color.Green, 100));
        }

        public void ApplyCollisions()
        {
            foreach (Collider other in others)
            {
                if (collisionEnterEffect != null)
                {
                    if (canCollide)
                    {
                        canCollide = false;
                        collisionEnterEffect(other);
                    }
                }
                if (continuousCollisionEffect != null)
                {
                    continuousCollisionEffect(other);
                }
                canCollide = true;
            }
        }

        public bool IsColliding(Collider other)
        {

            if (position.X < other.position.X + other.size.X &&
                position.X + size.X > other.position.X &&
                position.Y < other.position.Y + other.size.Y &&
                position.Y + size.Y > other.position.Y)
            {
                return true;
            }
            return false;
        }

        public string GetCollisionSide(Collider other)
        {
            string collidingSide = "";
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
            return collidingSide;
        }

        void ClearOthers()
        {
            others.Clear();
        }
    }
}
