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
        public bool enabled = true;
        public string name = "";
        public string layer = "";
        public Texture2D img;

        public virtual void Update(GameTime gameTime)
        {
        }

        public virtual void Draw()
        {
            if (img != null)
                MainGame.spriteBatch.Draw(img, position, Color.White);
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

        public virtual Vector2 GetSpawnPosition()
        {
            Vector2 spawnPos = new Vector2();
            Vector2 screenSize = Utils.GetScreenSize();

            spawnPos.X = screenSize.X * 0.5f - size.X * 0.5f;
            spawnPos.Y = screenSize.Y * 0.5f - size.Y * 0.5f;

            return spawnPos;
        }
    }
}
