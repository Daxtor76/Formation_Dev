using Soutenance_MonoGame.Constructors;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame.Interfaces
{
    public interface ICollidable
    {
        public void OnCollisionEnter(Collider other);
        public void OnCollision(Collider other);
    }
}
