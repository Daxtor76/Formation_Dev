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
    public class Brick : Entity, ICollidable, IDamageable
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

        int life;
        int maxLife;
        Collider col;
        BrickTypes brickType;
        Colors brickColor;

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

            EntityController.entities.Add(this);
        }

        public override void Update()
        {
            base.Update();
        }

        public override void Draw()
        {
            base.Draw();
        }

        public void OnCollisionEnter(Collider other, string side)
        {
        }

        public void OnCollision(Collider other, string side)
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

        public void Die()
        {
            enabled = false;
        }

        public int GetMaxLife(BrickTypes type, Colors color)
        {
            if (type != BrickTypes.littlebrick)
            {
                if (color == Colors.yellow || color == Colors.orange)
                    return 2;
                else if (color == Colors.red || color ==  Colors.purple)
                    return 3;
            }
            else
            {
               if (color == Colors.yellow || color == Colors.orange)
                    return 2;
            }

            return 1;
        }
    }
}
