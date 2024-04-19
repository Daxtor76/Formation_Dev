using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Mime;
using System.Diagnostics;
using Microsoft.Xna.Framework.Content;

namespace Soutenance_MonoGame
{
    public abstract class Entity : IEntity
    {
        public Vector2 position = new Vector2();
        public Vector2 baseSize = new Vector2();
        public Vector2 size = new Vector2();
        public Vector2 scale = new Vector2(1, 1);
        public float rotation = 0.0f;
        public string layer = "";
        public Texture2D img;
        public Rectangle sourceRect;

        bool enabled = true;
        bool active = true;
        string name = "";
        float layerDepth = 0.0f;

        public virtual void Start()
        {
            
        }

        public virtual void Update(GameTime gameTime)
        {
            sourceRect = new Rectangle(
                0,
                0,
                (int)baseSize.X,
                (int)baseSize.Y);
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
                MainGame.spriteBatch.Draw(img, destRect, sourceRect, Color.White, rotation, Vector2.Zero, SpriteEffects.None, layerDepth);
            }
        }

        public float GetRotation()
        {
            return rotation;
        }

        public void SetRotation(float pRotation)
        {
            rotation = pRotation;
        }

        public void SetPosition(Vector2 pPosition)
        {
            position = pPosition;
        }
        public void SetScale(Vector2 pScale)
        {
            scale = pScale;
            size = baseSize * pScale;
        }
        public Vector2 GetPosition()
        {
            return position;
        }
        public bool IsNear(Vector2 point, float distance)
        {
            float delta = Vector2.Distance(point, position);
            return delta <= distance;
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
            return position + size * 0.5f;
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
            SetEnabled(false);
        }

        public virtual void Unload()
        {
            SetEnabled(false);
        }

        public bool IsEnabled()
        {
            return enabled;
        }

        public void SetEnabled(bool value)
        {
            enabled = value;
        }

        public string GetName()
        {
            return name;
        }

        public void SetName(string name)
        {
            this.name = name;
        }

        public bool IsActive()
        {
            return active;
        }

        public void SetActive(bool value)
        {
            active = value;
        }

        public void SetLayerDepth(float value)
        {
            layerDepth = value;
        }

        public float GetLayerDepth()
        {
            return layerDepth;
        }

        public virtual Vector2 GetNewDirection()
        {
            return Vector2.Zero;
        }
    }
}
