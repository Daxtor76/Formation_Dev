using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using ProjectTemplate;
using ProjectTemplate.Constructors;
using ProjectTemplate.Controllers;
using ProjectTemplate.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame.Entities
{
    public class Wall : Entity, ICollidable
    {
        public Collider col;

        public Wall(Vector2 pPos, string pLayer, Vector2 pSize)
        {
            layer = pLayer;
            size = pSize;
            Position = pPos;
            col = new Collider(this, OnCollisionEnter, OnCollision);

            EntityController.entities.Add(this);
        }

        public Wall(Vector2 pPos, string pLayer, Texture2D pImg)
        {
            layer = pLayer;
            img = pImg;
            size = new Vector2(img.Width, img.Height);
            Position = pPos;
            col = new Collider(this, OnCollisionEnter, OnCollision);

            EntityController.entities.Add(this);
        }

        public void OnCollision(Collider other)
        {
        }

        public void OnCollisionEnter(Collider other)
        {
        }
    }
}
