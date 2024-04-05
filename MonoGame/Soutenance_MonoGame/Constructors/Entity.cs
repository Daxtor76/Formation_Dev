using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Mime;

namespace Soutenance_MonoGame
{
    public abstract class Entity
    {
        public Vector2 position = new Vector2();
        public Vector2 size = new Vector2();
        public Vector2 scale = new Vector2(1, 1);
        public float rotation = 0.0f;
        public bool enabled = true;
        public bool active = true;
        public string name = "";
        public string layer = "";
        public Texture2D img;
        public Rectangle sourceRect;

        public virtual void Update(GameTime gameTime)
        {
            sourceRect = new Rectangle(
                0,
                0,
                (int)size.X,
                (int)size.Y);
        }

        public virtual void Draw()
        {
            if (img != null)
            {
                Rectangle destRect = new Rectangle(
                    (int)position.X,
                    (int)position.Y,
                    (int)size.X,
                    (int)size.Y);
                MainGame.spriteBatch.Draw(img, destRect, sourceRect, Color.White, rotation, Vector2.Zero, SpriteEffects.None, 0.0f);
            }
        }
        public void SetPosition(Vector2 position)
        {
            this.position = position;
        }
        public Vector2 GetPosition()
        {
            return position;
        }
        public Vector2 GetSize()
        {
            return size;
        }

        public float GetDistance(Entity target)
        {
            return Vector2.Distance(position, target.position);
        }

        public Vector2 GetCenterPosition()
        {
            return position + size * 0.5f * scale;
        }

        public virtual Vector2 GetSpawnPosition()
        {
            Vector2 spawnPos = new Vector2();
            Vector2 screenSize = Utils.GetScreenSize();

            spawnPos.X = screenSize.X * 0.5f - size.X * 0.5f;
            spawnPos.Y = screenSize.Y * 0.5f - size.Y * 0.5f;

            return spawnPos;
        }

        public virtual void Destroy()
        {
            enabled = false;
        }
    }
}
