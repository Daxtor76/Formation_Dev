using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public interface ILevelElement
    {
        public void SetPosition(Vector2 position);
        public Vector2 GetPosition();
        public Vector2 GetSize();
        public void Unload();
    }
}
