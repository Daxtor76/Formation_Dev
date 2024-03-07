using Exo01.Constructors;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Exo01.Entities
{
    public class Warrior : Character
    {
        bool isRage = false;
        public Warrior(string pName, int pLife, int pStrength, int pIntellect) : base(pName, pLife, pStrength, pIntellect)
        {
            Debug.WriteLine($"{pName} enters in arena");
        }

        public void TriggerBerserkMode()
        {
            isRage = true;
            Debug.WriteLine($"{name} enters in Berserk mode");
        }

        public override void Hit(float damages)
        {
            Debug.WriteLine($"{name} says: Meh outch");

            if (life <= maxLife * 0.5f)
                TriggerBerserkMode();
        }

        public override void Attack(Character target)
        {
            string berserk = isRage ? " under Berserk" : "";
            Debug.WriteLine($"{name} attacks {target.name + berserk}");

            float damages = isRage ? strength * 2.5f : strength;
            Debug.WriteLine($"{target.name} has been hit and lost {damages} life points. Remaining life: {target.life}");

            base.Attack(target);

            if (target.life <= 0)
                Debug.WriteLine($"{target.name} is dead");
        }
    }
}
