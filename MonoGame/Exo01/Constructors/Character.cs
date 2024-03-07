using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Exo01.Constructors
{
    public abstract class Character
    {
        public string name;
        public int maxLife;
        public float life;
        public int strength;
        public int intellect;

        public Character(string pName, int pLife, int pStrength, int pIntellect)
        {
            name = pName;
            maxLife = pLife;
            life = maxLife;
            strength = pStrength;
            intellect = pIntellect;
        }

        public virtual void Hit(float damages)
        {
            Debug.WriteLine($"{name} says: Outch");
            life = Math.Clamp(life - damages, 0, maxLife);
        }

        public virtual void Heal(Character target, int amount)
        {
            target.life += amount;
            Debug.WriteLine($"{target.name} has been healed by {amount}");
        }

        public virtual void Attack(Character target)
        {
            target.Hit();
        }

//- Wizard Fireball()
    }
}
