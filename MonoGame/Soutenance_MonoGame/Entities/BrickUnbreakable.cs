using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class BrickBrickUnbreakable : Brick
    {
        public BrickBrickUnbreakable(BrickTypes pType, Colors pColor, string pName) : base(pType, pColor, pName)
        {
        }
        public BrickBrickUnbreakable(string pType, Colors pColor, string pName, Vector2 pPos) : base(pType, pColor, pName, pPos)
        {
        }
    }
}
