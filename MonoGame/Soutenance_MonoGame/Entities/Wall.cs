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
    public class Wall : Entity, ICollidable, ILevelElement
    {
        public Collider col;

        public Wall(Vector2 pPos, string pName, Vector2 pSize)
        {
            name = pName;
            layer = "Wall";
            size = pSize;
            position = pPos;
            col = new Collider(this, scale, OnCollisionEnter, OnCollision);

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public Wall(Vector2 pPos, string pName, Texture2D pImg)
        {
            name = pName;
            layer = "Wall";
            img = pImg;
            size = new Vector2(img.Width, img.Height);
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

        public void Unload()
        {
            enabled = false;
        }
    }
}
