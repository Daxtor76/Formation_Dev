using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
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
        public int life;
        public Collider col;

        int maxLife;

        public Brick(Texture2D pImg, Vector2 pPos, int pLife, string pName, string pLayer)
        {
            name = pName;
            layer = pLayer;
            img = pImg;
            size = new Vector2(img.Width, img.Height);
            position = pPos;
            col = new Collider(this, OnCollisionEnter, OnCollision);

            life = pLife;
            maxLife = life;

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
            Debug.WriteLine(life);
        }

        public void Die()
        {
            throw new NotImplementedException();
        }
    }
}
