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
        public BrickPowerUp(string pType, Colors pColor, string pName, Vector2 pPos) : base(pType, pColor, pName, pPos)
        {
        }

        public void DropPowerUp(PowerUp.PowerUpTypes powerUpType)
        {
            new PowerUp(new Vector2(position.X + size.X * 0.5f, position.Y + size.Y), powerUpType);
        }

        public override void Die()
        {
            Array powerUpTypes = Enum.GetValues<PowerUp.PowerUpTypes>();
            Random rand = new Random();
            DropPowerUp((PowerUp.PowerUpTypes)powerUpTypes.GetValue(rand.Next(0, powerUpTypes.Length - 1)));
            base.Die();
        }
    }
}
