using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using ProjectTemplate.Constructors;
using ProjectTemplate.Controllers;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Entities
{
    public class Hero : Entity
    {
        public Texture2D img;
        public Collider col;
        public Mover mover;

        public Hero(MainGame pProjectGame, Texture2D pImg, Vector2 pPos, string pName, string pLayer) : base(pProjectGame)
        {
            name = pName;
            layer = pLayer;
            projectGame = pProjectGame;
            position = pPos;
            img = pImg;
            size = new Vector2(img.Width, img.Height);
            col = new Collider(pProjectGame, this, OnCollisionEnter);
            mover = new Mover(this);

            EntityController.entities.Add(this);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            mover.Move(gameTime, mover.GetInputDirection(), 200.0f);
        }

        public override void Draw(GameTime gameTime)
        {
            base.Draw(gameTime);
            projectGame._spriteBatch.Draw(img, position, Color.White);
        }

        void OnCollisionEnter()
        {
            Debug.WriteLine("Hit");
        }
    }
}
