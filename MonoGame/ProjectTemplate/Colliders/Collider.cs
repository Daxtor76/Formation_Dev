using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Colliders
{
    public class Collider
    {
        protected MainGame projectGame;
        public Vector2 position;
        public Vector2 size;
        public object parent;
        public bool enabled = true;
        public delegate void CallBack();
        CallBack collisionEffect;


        Texture2D texture;
        Rectangle rect;

        // Build this constructor after creating Entity class
        //public Collider(object pParent)
        //{
        //    position = parent.position;
        //}

        public Collider(MainGame pProjectGame, Vector2 pPosition, Vector2 pSize, object pParent = null, CallBack pCollisionEffect = null)
        {
            projectGame = pProjectGame;
            position = pPosition;
            size = pSize;
            parent = pParent;
            collisionEffect = pCollisionEffect;

            texture = new Texture2D(projectGame._graphics.GraphicsDevice, 1, 1);
            texture.SetData(new[] { Color.Green });

            rect = new Rectangle((int)position.X, (int)position.Y, (int)size.X, (int)size.Y);

            CollisionController.collidersList.Add(this);
        }

        public void Draw()
        {
            projectGame._spriteBatch.Draw(texture, rect, Color.Green);
        }

        public void UpdatePosition(GameTime gameTime)
        {
            // Update this function after creating Entity class
            rect.X += (int)(100 * (float)gameTime.ElapsedGameTime.TotalSeconds);
            if(parent != null)
            {
                //position = parent.position;
            }
        }

        public void CheckCollision(Collider other)
        {
            if(position.X < other.position.X + other.size.X &&
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
