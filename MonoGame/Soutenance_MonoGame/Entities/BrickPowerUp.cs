using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class BrickPowerUp : Brick, IDamageable
    {
        public BrickPowerUp(BrickTypes pType, Colors pColor, string pName) : base(pType, pColor, pName)
        {
        }

        public void DropPowerUp(PowerUp.PowerUpTypes powerUpType)
        {
            new PowerUp(new Vector2(position.X + size.X * 0.5f, position.Y + size.Y), powerUpType);
        }

        public override void Die()
        {
            DropPowerUp(PowerUp.PowerUpTypes.multiball);
            base.Die();
        }
    }
}
