using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class UnbreakableBrick : Brick
    {
        public UnbreakableBrick(BrickTypes pType, string pName) : base(pType, pName)
        {
            brickColor = Colors.grey;
        }
    }
}
