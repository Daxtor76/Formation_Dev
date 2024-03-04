using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using ProjectTemplate.Controllers;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Constructors
{
    public class Collider : Entity
    {
        public Entity parent;
        public delegate void CallBack();
        CallBack collisionEffect;

        Texture2D texture;
        Rectangle rect;

        public Collider(MainGame pProjectGame, Entity pParent, CallBack pCollisionEffect = null) : base(pProjectGame)
        {
            parent = pParent;
            position = pParent.position;
            size = pParent.size;
            collisionEffect = pCollisionEffect;

            texture = new Texture2D(projectGame._graphics.GraphicsDevice, 1, 1);
            texture.SetData(new[] { Color.Green });

            rect = new Rectangle((int)position.X, (int)position.Y, (int)size.X, (int)size.Y);

            CollisionController.collidersList.Add(this);
        }

        public Collider(MainGame pProjectGame, Vector2 pPosition, Vector2 pSize, CallBack pCollisionEffect = null) : base(pProjectGame)
        {
            position = pPosition;
            size = pSize;
            collisionEffect = pCollisionEffect;

            texture = new Texture2D(projectGame._graphics.GraphicsDevice, 1, 1);
            texture.SetData(new[] { Color.Green });

            rect = new Rectangle((int)position.X, (int)position.Y, (int)size.X, (int)size.Y);

            CollisionController.collidersList.Add(this);
        }

        public void Draw()
        {
            projectGame._spriteBatch.Draw(texture, rect, new Color(Color.Green, 100));
        }

        public void UpdatePosition(GameTime gameTime)
        {
            if (parent != null)
            {
                position = parent.position;
                rect.X = (int)position.X;
                rect.Y = (int)position.Y;
            }
        }

        public void CheckCollision(Collider other)
        {
            if (position.X < other.position.X + other.size.X &&
                position.X + size.X > other.position.X &&
                position.Y < other.position.Y + other.size.Y &&
                position.Y + size.Y > other.position.Y)
            {
                if (collisionEffect != null)
                    collisionEffect();
            }
        }
    }
}
