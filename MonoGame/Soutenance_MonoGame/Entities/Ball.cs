using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
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

        public Ball(Texture2D pImg, float pSpeed, Vector2 pDirection, string pName, string pLayer) : base(pSpeed, pDirection)
        {
            name = pName;
            layer = pLayer;
            img = pImg;
            size = new Vector2(img.Width, img.Height);
            position = GetSpawnPosition();
            col = new Collider(this, OnCollisionEnter, OnCollision);

            EntityController.entities.Add(this);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            // TO DO: voir si on peut pas ranger ça ailleurs
            col.oldPosition = col.position;
        }

        float GetImpactPointRelativePosition(Entity target)
        {
            float ballCenterPos = position.X + size.X * 0.5f;
            float targetCenterPos = target.position.X + target.size.X * 0.5f;
            float targetSizeHalf = target.size.X * 0.5f;
            return -(targetCenterPos - ballCenterPos) / targetSizeHalf;
        }

        public void OnCollisionEnter(Collider other, string side)
        {
            if (side == "bottom" && other.parent.layer == "Wall")
            {
                position = Utils.GetScreenCenter();
            }

            if (other.parent.layer == "Paddle")
            {
                float modifier = GetImpactPointRelativePosition(other.parent);
                direction = Vector2.Normalize(new Vector2(modifier, -direction.Y));
            }
            else
            {
                if (side == "top" || side == "bottom")
                    direction.Y = -direction.Y;
                else if (side == "left" || side == "right")
                    direction.X = -direction.X;
            }

            if (other.parent is IDamageable)
            {
                IDamageable parent = other.parent as IDamageable;
                parent.TakeDamages(1);
            }
        }

        public void OnCollision(Collider other, string side)
        {
        }
    }
}
