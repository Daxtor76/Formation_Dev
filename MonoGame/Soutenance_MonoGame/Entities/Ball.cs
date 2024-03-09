using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Soutenance_MonoGame;
using Soutenance_MonoGame.Constructors;
using Soutenance_MonoGame.Controllers;
using Soutenance_MonoGame.Interfaces;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame.Entities
{
    public class Ball : AbstractMoveable, ICollidable
    {
        public Collider col;

        public Ball(Texture2D pImg, Vector2 pPos, float pSpeed, Vector2 pDirection, string pName, string pLayer) : base(pSpeed, pDirection)
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
        }

        float GetImpactPointRelativePosition(Entity target)
        {
            return (Position.X - target.Position.X) / (target.size.X * 0.5f);
        }

        public void OnCollisionEnter(Collider other)
        {
            if (other.parent.layer == "Paddle")
            {
                float modifier = GetImpactPointRelativePosition(other.parent);
                direction = new Vector2(modifier, -direction.Y);
            }
            else
                direction = -direction;
        }

        public void OnCollision(Collider other)
        {
        }
    }
}
