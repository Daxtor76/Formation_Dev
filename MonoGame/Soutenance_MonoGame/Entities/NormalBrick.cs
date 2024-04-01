using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class NormalBrick : Brick, IDamageable
    {
        public NormalBrick(BrickTypes pType, Colors pColor, string pName) : base(pType, pColor, pName)
        {
        }
    }
}
