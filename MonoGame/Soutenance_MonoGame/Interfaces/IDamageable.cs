using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame.Interfaces
{
    public interface IDamageable
    {
        public void TakeDamages(int amount);
        public void Die();
    }
}
