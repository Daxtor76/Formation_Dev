using Microsoft.Xna.Framework;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class PowerUp : Entity, ICollidable
    {
        public enum PowerUpTypes
        {
            multiball
        }

        protected PowerUpTypes type;
        protected Collider col;
        protected Mover mover;

        public PowerUp(Vector2 pPos, PowerUpTypes pType)
        {
            type = pType;
            name = "PowerUp" + ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<PowerUp>().Count;
            layer = "PowerUp";
            img = ServiceLocator.GetService<ISpritesManager>().GetPowerUpTexture($"powerup_{pType}_spritesheet");
            size = new Vector2(30.0f, img.Height);
            position = new Vector2(pPos.X - size.X * 0.5f, pPos.Y - size.Y);

            col = new Collider(this, scale, OnCollisionEnter, OnCollision);
            mover = new Mover(100.0f);

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            mover.Move(gameTime, this, new Vector2(0, 1), new Vector2(1, 1));
        }

        public void OnCollision(Collider other)
        {
        }

        public void OnCollisionEnter(Collider other)
        {
        }
    }
}
