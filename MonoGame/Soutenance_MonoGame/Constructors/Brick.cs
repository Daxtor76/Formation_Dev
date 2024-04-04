using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace Soutenance_MonoGame
{
    public abstract class Brick : Entity, ICollidable, ILevelElement
    {
        public enum BrickTypes
        {
            littlebrick,
            brick,
            bigbrick,
            powerupbrick
        }
        public enum Colors
        {
            grey,
            green,
            yellow,
            orange,
            red,
            purple
        }

        protected int life;
        protected int maxLife;
        protected Collider col;
        protected BrickTypes type;
        protected Colors color;

        public Brick(BrickTypes pType, Colors pColor, string pName)
        {
            name = pName;
            layer = "Brick";
            type = pType;
            color = pColor;
            img = ServiceLocator.GetService<ISpritesManager>().GetBrickTexture(pType + "_" + pColor + "_" + (maxLife - life).ToString() + "hit");
            size = new Vector2(img.Width, img.Height);
            position = Vector2.Zero;

            col = new Collider(this, scale, OnCollisionEnter, OnCollision);

            maxLife = GetMaxLife(type, color);
            life = maxLife;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
        }

        public override void Draw()
        {
            base.Draw();
        }

        public void OnCollisionEnter(List<Collider> others)
        {
        }

        public void OnCollision(List<Collider> others)
        {
        }

        public void TakeDamages(int amount)
        {
            life = Math.Clamp(life - amount, 0, maxLife);

            if (life <= 0)
                Die();
            else
                img = ServiceLocator.GetService<ISpritesManager>().GetBrickTexture(type + "_" + color + "_" + (maxLife - life).ToString() + "hit");
        }

        public int GetMaxLife(BrickTypes type, Colors color)
        {
            if (type == BrickTypes.bigbrick)
            {
                if (color == Colors.yellow || color == Colors.orange)
                    return 2;
                else if (color == Colors.red || color == Colors.purple)
                    return 3;
            }
            else if (type == BrickTypes.brick || type == BrickTypes.littlebrick)
            {
                if (color == Colors.yellow || color == Colors.orange)
                    return 2;
            }

            return 1;
        }

        public virtual void Die()
        {
            Destroy();
        }

        public virtual void Unload()
        {
            Destroy();
        }
    }
}
