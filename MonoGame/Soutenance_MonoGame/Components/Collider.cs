using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.Design;

namespace Soutenance_MonoGame
{
    public class Collider : Entity
    {
        public Entity parent {get; private set;}
        public Vector2 oldPosition;
        public List<Collider> others = new List<Collider>();
        public List<string> previousOthers = new List<string>();
        public delegate void CallBackOthersEffect(List<Collider> others);
        CallBackOthersEffect collisionEnterEffect;
        CallBackOthersEffect collisionEnterOthersEffect;

        Texture2D texture;

        public Collider(Entity pParent, Vector2 pScale, CallBackOthersEffect pCollisionEffect = null, CallBackOthersEffect pContinuousCollisionEffect = null)
        {
            parent = pParent;
            scale = pScale;
            size = pParent.size * pScale;
            position = pParent.position;
            collisionEnterEffect = pCollisionEffect;
            collisionEnterOthersEffect = pContinuousCollisionEffect;

            texture = new Texture2D(MainGame.graphics.GraphicsDevice, 1, 1);
            texture.SetData(new[] { Color.Green });

            ServiceLocator.GetService<ICollisionManager>().AddCollider(this);
        }

        public override void Update(GameTime gameTime)
        {
            if (parent != null)
            {
                position = parent.position + parent.size * scale - size * scale;
            }
        }

        public override void Draw()
        {
            if (MainGame.debugMode)
            {
                Rectangle sourceRect = new Rectangle(
                    0,
                    0,
                    (int)size.X,
                    (int)size.Y);
                Rectangle destRect = new Rectangle(
                    (int)position.X,
                    (int)position.Y,
                    (int)size.X,
                    (int)size.Y);
                MainGame.spriteBatch.Draw(texture, destRect, sourceRect, new Color(Color.Green, 100), 0.0f, Vector2.Zero, SpriteEffects.None, 0.0f);
            }
        }

        public void ApplyCollisions(List<Collider> others)
        {
            if (collisionEnterEffect != null)
            {
                collisionEnterEffect(others);
            }
            if (collisionEnterOthersEffect != null)
            {
                collisionEnterOthersEffect(others);
            }
        }

        public bool IsColliding(Collider other)
        {
            // top left
            if (position.X >= other.position.X &&
                position.X <= other.position.X + other.size.X &&
                position.Y >= other.position.Y &&
                position.Y <= other.position.Y + other.size.Y)
            {
                return true;
            }
            // top right
            if (position.X + size.X >= other.position.X &&
                position.X + size.X <= other.position.X + other.size.X &&
                position.Y >= other.position.Y &&
                position.Y <= other.position.Y + other.size.Y)
            {
                return true;
            }
            // bottom right
            if (position.X + size.X >= other.position.X &&
                position.X + size.X <= other.position.X + other.size.X &&
                position.Y + size.Y >= other.position.Y &&
                position.Y + size.Y <= other.position.Y + other.size.Y)
            {
                return true;
            }
            // bottom left
            if (position.X >= other.position.X &&
                position.X <= other.position.X + other.size.X &&
                position.Y + size.Y >= other.position.Y &&
                position.Y + size.Y <= other.position.Y + other.size.Y)
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

        public void StorePreviousOthers()
        {
            previousOthers.Clear();
            foreach (Collider col in others)
            {
                previousOthers.Add(col.parent.name);
            }
        }
    }
}
