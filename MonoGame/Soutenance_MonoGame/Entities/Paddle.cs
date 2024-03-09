using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using ProjectTemplate.Constructors;
using ProjectTemplate.Controllers;
using ProjectTemplate.Interfaces;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Entities
{
    public class Paddle : AbstractMoveable, ICollidable
    {
        public Collider col;

        public Paddle(Texture2D pImg, Vector2 pPos, float pSpeed, string pName, string pLayer) : base(pSpeed)
        {
            name = pName;
            layer = pLayer;
            img = pImg;
            size = new Vector2(img.Width, img.Height);
            Position = pPos;
            col = new Collider(this, OnCollisionEnter, OnCollision);

            EntityController.entities.Add(this);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            direction = GetInputDirection();
            //Move(gameTime);
        }

        public void OnCollisionEnter(Collider other)
        {
        }

        public void OnCollision(Collider other)
        {
        }
    }
}
