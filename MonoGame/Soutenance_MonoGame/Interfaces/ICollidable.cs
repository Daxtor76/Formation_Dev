using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static ProjectTemplate.Constructors.Collider;

namespace ProjectTemplate.Interfaces
{
    public interface ICollidable
    {
        public void OnCollisionEnter();
        public void OnCollision();
    }
}
