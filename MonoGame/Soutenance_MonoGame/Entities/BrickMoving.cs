using Microsoft.Xna.Framework;
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
        public BrickMoving(BrickTypes pType, Colors pColor, string pName) : base(pType, pColor, pName)
        {
            CreateEyesPerLifepoints(maxLife);
            mover = new Mover(100.0f);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            //mover.MoveSmoothly()
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
