using Exo01.Constructors;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Exo01.Entities
{
    public class Wizard : Character
    {
        public Wizard(string pName, int pLife, int pStrength, int pIntellect) : base(pName, pLife, pStrength, pIntellect)
        {
            Debug.WriteLine($"{pName} enters in arena");
        }

        public override void Hit(float damages)
        {
            Debug.WriteLine($"{name} says: Very outch");
        }

        public override void Attack(Character target)
        {
            Debug.WriteLine($"{name} attacks {target.name}");

            target.life = Math.Clamp(target.life - intellect, 0, target.maxLife);
            Debug.WriteLine($"{target.name} has been hit and lost {intellect} life points. Remaining life: {target.life}");

            base.Attack(target);

            if (target.life <= 0)
                Debug.WriteLine($"{target.name} is dead");
        }

        public void CastFireBall(Character target)
        {
            Debug.WriteLine($"{name} casts a fireball on {target.name}");

            float damages = intellect * 2.5f;

            Debug.WriteLine($"{target.name} has been hit and lost {damages} life points");

            target.Hit();

            if (target.life <= 0)
                Debug.WriteLine($"{target.name} is dead");
        }
    }
}
