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
    public class Hero : AbstractMoveable, ICollidable
    {
        public Texture2D img;
        public Collider col;

        public Hero(MainGame pProjectGame, Texture2D pImg, Vector2 pPos, float pSpeed, string pName, string pLayer) : base(pProjectGame, pSpeed)
        {
            name = pName;
            layer = pLayer;
            position = pPos;
            img = pImg;
            size = new Vector2(img.Width, img.Height);
            col = new Collider(pProjectGame, this, OnCollisionEnter, OnCollision);

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
            projectGame._spriteBatch.Draw(img, position, Color.White);
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
