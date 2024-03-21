using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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

        public virtual void Update()
        {
        }

        public virtual void Update(GameTime gameTime)
        {
        }

        public virtual void Draw()
        {
            if (img != null)
                MainGame.spriteBatch.Draw(img, position, Color.White);
        }

        public virtual Vector2 GetSpawnPosition()
        {
            Vector2 spawnPos = new Vector2();

            spawnPos.X = MainGame.graphics.PreferredBackBufferWidth * 0.5f - size.X * 0.5f;
            spawnPos.Y = MainGame.graphics.PreferredBackBufferHeight * 0.5f - size.Y * 0.5f;

            return spawnPos;
        }
    }
}
