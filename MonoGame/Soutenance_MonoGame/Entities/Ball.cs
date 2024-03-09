using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using ProjectTemplate;
using ProjectTemplate.Constructors;
using ProjectTemplate.Controllers;
using ProjectTemplate.Interfaces;
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

        float GetAngleFromTarget(Entity target)
        {
            Vector2 delta = target.Position - Position;
            float angle = 0.0f;



            return angle;
        }

        public void OnCollisionEnter(Collider other)
        {
            direction = -direction;
            if (other.parent.layer == "Paddle")
            {
                float distance = (other.parent.Position - Position).Length();
                Debug.WriteLine($"Distance from paddle center: {distance - size.Y}");
            }
        }

        public void OnCollision(Collider other)
        {
        }
    }
}
