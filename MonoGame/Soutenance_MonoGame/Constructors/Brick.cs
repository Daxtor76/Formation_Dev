﻿using Microsoft.Xna.Framework;
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
    public abstract class Brick : Entity, ICollidable
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

        public int life;
        protected int maxLife;
        protected Collider col;
        public BrickTypes type;
        protected Colors color;
        protected List<Entity> googlyEyes;

        public Brick()
        {
        
        }

        public Brick(BrickTypes pType, Colors pColor, string pName)
        {
            SetName(pName);
            layer = "Brick";
            type = pType;
            color = pColor;
            img = ServiceLocator.GetService<ISpritesManager>().GetBrickTexture(pType + "_" + pColor + "_" + (maxLife - life).ToString() + "hit");
            baseSize = new Vector2(img.Width, img.Height);
            size = baseSize * scale;
            position = Vector2.Zero;

            col = new Collider(this, scale, OnCollisionEnter, OnCollision);

            maxLife = GetMaxLife(type, color);
            life = maxLife;
            googlyEyes = new List<Entity>();

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public Brick(string pType, Colors pColor, string pName, Vector2 pPos)
        {
            SetName(pName);
            layer = "Brick";

            switch (pType)
            {
                case "littlebrick":
                    type = BrickTypes.littlebrick;
                    break;
                case "powerupbrick":
                    type = BrickTypes.powerupbrick;
                    break;
                case "bigbrick":
                    type = BrickTypes.bigbrick;
                    break;
                case "brick":
                    type = BrickTypes.brick;
                    break;
            }

            color = pColor;
            img = ServiceLocator.GetService<ISpritesManager>().GetBrickTexture(pType + "_" + pColor + "_" + (maxLife - life).ToString() + "hit");
            baseSize = new Vector2(img.Width, img.Height);
            size = baseSize * scale;
            position = pPos;

            col = new Collider(this, scale, OnCollisionEnter, OnCollision);

            maxLife = GetMaxLife(type, color);
            life = maxLife;
            googlyEyes = new List<Entity>();

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
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
            if (googlyEyes.Count != 0)
                googlyEyes[life].Destroy();

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
            Unload();
        }

        public override void Unload()
        {
            foreach (IEntity ge in googlyEyes)
                ge.Unload();

            googlyEyes.Clear();

            base.Unload();
        }
    }
}
