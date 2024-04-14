using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
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
        public BrickNormal(string pType, Colors pColor, string pName, Vector2 pPos) : base(pType, pColor, pName, pPos)
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
