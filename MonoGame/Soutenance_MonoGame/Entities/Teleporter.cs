using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class Teleporter : Entity, ILevelElement, ICollidable
    {
        public string destinationName;
        public Vector2 newDirection;
        public Collider col;
        public Teleporter(Vector2 pPos, float pRotation, string pdestinationName, Vector2 pNewDirection, string pName)
        {
            name = pName;
            layer = "Teleporter";
            img = ServiceLocator.GetService<ISpritesManager>().GetPortalTexture();
            size = new Vector2(53.3f, 92.0f);
            position = pPos;
            rotation = pRotation;
            destinationName = pdestinationName;
            newDirection = pNewDirection;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);

            col = new Collider(this, new Vector2(0.5f, 0.5f), OnCollisionEnter, OnCollision);
        }

        public override void Draw()
        {
            if (img != null)
            {
                Rectangle destRect = new Rectangle(
                    (int)(position.X + size.X * 0.5f),
                    (int)(position.Y + size.Y * 0.5f),
                    (int)size.X,
                    (int)size.Y);
                MainGame.spriteBatch.Draw(img, destRect, sourceRect, Color.White, rotation, new Vector2(size.X * 0.5f, size.Y * 0.5f), SpriteEffects.None, 1.0f);
            }
        }

        public void OnCollision(List<Collider> others)
        {
        }

        public void OnCollisionEnter(List<Collider> others)
        {
        }

        public void Unload()
        {
            enabled = false;
        }
    }
}
