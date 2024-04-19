using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class BrickUnbreakable : Brick
    {
        public BrickUnbreakable(BrickTypes pType, Colors pColor, string pName) : base(pType, pColor, pName)
        {
        }
        public BrickUnbreakable(string pType, Colors pColor, string pName, Vector2 pPos) : base(pType, pColor, pName, pPos)
        {
        }
    }
}
