using Microsoft.Xna.Framework;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Drawing;

namespace Soutenance_MonoGame
{
    public class PowerUp : Entity, ICollidable
    {
        public enum PowerUpTypes
        {
            multiball
        }

        public PowerUpTypes type;
        public Collider col;
        public Mover mover;
        public delegate void Effect();
        public Effect powerUpEffect;

        public PowerUp(Vector2 pPos, PowerUpTypes pType)
        {
            type = pType;
            name = "PowerUp" + ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<PowerUp>().Count;
            layer = "PowerUp";
            img = ServiceLocator.GetService<ISpritesManager>().GetPowerUpTexture($"powerup_{pType}_spritesheet");
            size = new Vector2(30.0f, img.Height);
            position = new Vector2(pPos.X - size.X * 0.5f, pPos.Y - size.Y);

            switch (pType)
            {
                case PowerUpTypes.multiball:
                    powerUpEffect = MultiBallEffect;
                    break;
            }

            col = new Collider(this, scale, OnCollisionEnter, OnCollision);
            mover = new Mover(100.0f);

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            mover.Move(gameTime, this, new Vector2(0, 1), new Vector2(1, 1));
        }

        public void MultiBallEffect()
        {
            Debug.WriteLine("multibaaaaaall");
        }

        public void OnCollision(List<Collider> others)
        {
            foreach (Collider other in others)
            {
                if (!col.previousOthers.Contains(other.parent.name))
                {
                    string side = col.GetCollisionSide(other);
                    if (other.parent.layer == "Wall")
                    {
                        if (side == "bottom")
                            Destroy();
                    }
                    else if (other.parent.layer == "Paddle")
                    {
                        powerUpEffect();
                        Destroy();
                    }
                }
            }
        }

        public void OnCollisionEnter(List<Collider> others)
        {
        }
    }
}
