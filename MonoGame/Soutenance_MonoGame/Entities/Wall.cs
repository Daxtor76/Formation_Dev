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
    public class Wall : Entity, ICollidable
    {
        public Collider col;

        public Wall(Vector2 pPos, string pName, Vector2 pSize)
        {
            SetName(pName);
            layer = "Wall";
            baseSize = pSize;
            size = baseSize * scale;
            position = pPos;
            col = new Collider(this, scale, OnCollisionEnter, OnCollision);

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public Wall(Vector2 pPos, string pName, Texture2D pImg)
        {
            SetName(pName);
            layer = "Wall";
            img = pImg;
            baseSize = new Vector2(img.Width, img.Height);
            size = baseSize * scale;
            position = pPos;
            col = new Collider(this, scale, OnCollisionEnter, OnCollision);

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public void OnCollision(List<Collider> others)
        {
        }

        public void OnCollisionEnter(List<Collider> others)
        {
        }

        public override void Unload()
        {
            base.Unload();
        }
    }
}
