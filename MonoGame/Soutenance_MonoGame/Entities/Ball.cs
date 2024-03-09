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
            {
                bool isAboveAC = isOnUpperSideOfLine(other.corners["bottomRight"], other.corners["topLeft"], Position);
                bool isAboveDB = isOnUpperSideOfLine(other.corners["topRight"], other.corners["bottomLeft"], Position);

                if (isAboveAC)
                {
                    if (isAboveDB)
                        // top edge
                        direction.Y = -direction.Y;
                    else
                        // right edge
                        direction.X = -direction.X;
                }
                else
                {
                    if (isAboveDB)
                    {
                        if (isAboveDB)
                            // left edge
                            direction.X = -direction.X;
                        else
                            // bottom edge
                            direction.Y = -direction.Y;
                    }
                }    
            }
        }

        public void OnCollision(Collider other)
        {
        }

        bool isOnUpperSideOfLine(Vector2 corner1, Vector2 oppositeCorner, Vector2 ballCenter)
        {
            return ((oppositeCorner.X - corner1.X) * (ballCenter.Y - corner1.Y) - (oppositeCorner.Y - corner1.Y) * (ballCenter.X - corner1.X)) > 0;
        }
    }
}
