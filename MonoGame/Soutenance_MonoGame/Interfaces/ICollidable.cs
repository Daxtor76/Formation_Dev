using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public interface ICollidable
    {
        public void OnCollisionEnter(List<Collider> others);
        public void OnCollision(List<Collider> others);
    }
}
