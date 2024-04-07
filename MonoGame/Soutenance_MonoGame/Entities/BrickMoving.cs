using Microsoft.Xna.Framework;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class BrickMoving : Brick, IDamageable
    {
        Mover mover;
        Vector2 point1;
        Vector2 point2;
        Vector2 destination;
        float currentTimer;
        public BrickMoving(BrickTypes pType, Colors pColor, string pName, Vector2 pPoint2) : base(pType, pColor, pName)
        {
            CreateEyesPerLifepoints(maxLife);
            mover = new Mover(1.0f);
            point2 = pPoint2;

            Random rand = new Random();
            currentTimer = 0.0f;

            Start();
        }

        public override void Start()
        {
            point1 = position;
            point2 += position;

            destination = point2;
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;

            Random rand = new Random();

            if (IsNear(point2, 50.0f))
            {
                currentTimer -= dt;

                if (currentTimer <= 0.0f)
                {
                    destination = point1;
                    currentTimer = (float)rand.NextDouble() * rand.Next(0, 3);
                }
            }
            else if (IsNear(point1, rand.Next(10, 50)))
            {
                currentTimer -= dt;

                if (currentTimer <= 0.0f)
                {
                    destination = point2;
                    currentTimer = (float)rand.NextDouble() * rand.Next(0, 3);
                }
            }

            mover.MoveTo(gameTime, this, destination, new Vector2(2.0f));
        }

        private void CreateEyesPerLifepoints(int lp)
        {
            for (int i = 0; i < lp; i++)
            {
                googlyEyes.Add(new GooglyEyes(this, i));
            }
        }
    }
}
