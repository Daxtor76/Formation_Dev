using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class BrickNormal : Brick, IDamageable
    {
        public BrickNormal(BrickTypes pType, Colors pColor, string pName) : base(pType, pColor, pName)
        {
            CreateEyesPerLifepoints(maxLife);
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
