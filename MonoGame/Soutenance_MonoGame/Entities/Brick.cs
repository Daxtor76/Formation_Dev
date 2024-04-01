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
            bigbrick
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
        protected BrickTypes brickType;
        protected Colors brickColor;

        public Brick(BrickTypes pType, Colors pColor, string pName)
        {
            name = pName;
            layer = "Brick";
            brickType = pType;
            brickColor = pColor;
            img = ServiceLocator.GetService<ISpritesManager>().GetBrickTexture(pType + "_" + pColor + "_" + (maxLife - life).ToString() + "hit");
            size = new Vector2(img.Width, img.Height);
            position = Vector2.Zero;

            col = new Collider(this, OnCollisionEnter, OnCollision);

            maxLife = GetMaxLife(brickType, brickColor);
            life = maxLife;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public Brick(BrickTypes pType, string pName)
        {
            name = pName;
            layer = "Brick";
            brickType = pType;
            img = ServiceLocator.GetService<ISpritesManager>().GetBrickTexture(pType + "_" + brickColor + "_" + (maxLife - life).ToString() + "hit");
            size = new Vector2(img.Width, img.Height);
            position = Vector2.Zero;

            col = new Collider(this, OnCollisionEnter, OnCollision);

            maxLife = GetMaxLife(brickType, brickColor);
            life = maxLife;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public Brick(BrickTypes pType, Colors pColor, Vector2 pPos, string pName)
        {
            name = pName;
            layer = "Brick";
            brickType = pType;
            brickColor = pColor;
            img = ServiceLocator.GetService<ISpritesManager>().GetBrickTexture(pType + "_" + pColor + "_" + (maxLife - life).ToString() + "hit");
            size = new Vector2(img.Width, img.Height);
            position = pPos;
            col = new Collider(this, OnCollisionEnter, OnCollision);

            maxLife = GetMaxLife(brickType, brickColor);
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

        public void OnCollisionEnter(Collider other)
        {
        }

        public void OnCollision(Collider other)
        {
        }

        public void TakeDamages(int amount)
        {
            life = Math.Clamp(life - amount, 0, maxLife);

            if (life <= 0)
                Die();
            else
                img = ServiceLocator.GetService<ISpritesManager>().GetBrickTexture(brickType + "_" + brickColor + "_" + (maxLife - life).ToString() + "hit");
        }

        public int GetMaxLife(BrickTypes type, Colors color)
        {
            if (type != BrickTypes.littlebrick)
            {
                if (color == Colors.yellow || color == Colors.orange)
                    return 2;
                else if (color == Colors.red || color == Colors.purple)
                    return 3;
            }
            else
            {
                if (color == Colors.yellow || color == Colors.orange)
                    return 2;
            }

            return 1;
        }

        public void Die()
        {
            enabled = false;
        }

        public void Unload()
        {
            enabled = false;
        }
    }
}
