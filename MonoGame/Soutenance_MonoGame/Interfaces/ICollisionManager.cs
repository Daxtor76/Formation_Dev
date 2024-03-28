using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public interface ICollisionManager
    {
        public void AddCollider(Collider col);
        public void UpdateColliders();
        public void DrawColliders();
        public void CleanColliders();
    }
}
