using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
using Soutenance_MonoGame.Constructors;
using Soutenance_MonoGame.Controllers;
using Soutenance_MonoGame.Interfaces;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame.Entities
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
            img = MainGame._content.Load<Texture2D>($"Bricks/{brickType}_{brickColor}");
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
