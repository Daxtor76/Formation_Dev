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
        public Texture2D img;
        public Collider col;

        public Paddle(Texture2D pImg, Vector2 pPos, float pSpeed, string pName, string pLayer) : base(pSpeed)
        {
            name = pName;
            layer = pLayer;
            img = pImg;
            size = new Vector2(img.Width, img.Height);
            position = pPos - size * 0.5f;
            col = new Collider(this, OnCollisionEnter, OnCollision);

            EntityController.entities.Add(this);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            Move(gameTime, GetInputDirection());
        }

        public override void Draw(GameTime gameTime)
        {
            base.Draw(gameTime);
            MainGame._spriteBatch.Draw(img, position, Color.White);
        }

        public void OnCollisionEnter()
        {
            Debug.WriteLine("Hit");
        }

        public void OnCollision()
        {
            Debug.WriteLine("Hit multiple times");
        }
    }
}
