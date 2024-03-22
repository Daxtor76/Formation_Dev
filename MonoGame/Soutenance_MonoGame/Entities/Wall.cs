﻿using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class Wall : Entity, ICollidable
    {
        public Collider col;

        public Wall(Vector2 pPos, string pLayer, Vector2 pSize)
        {
            layer = pLayer;
            size = pSize;
            position = pPos;
            col = new Collider(this, OnCollisionEnter, OnCollision);

            EntityController.entities.Add(this);
        }

        public Wall(Vector2 pPos, string pLayer, Texture2D pImg)
        {
            layer = pLayer;
            img = pImg;
            size = new Vector2(img.Width, img.Height);
            position = pPos;
            col = new Collider(this, OnCollisionEnter, OnCollision);

            EntityController.entities.Add(this);
        }

        public void OnCollision(Collider other, string side)
        {
        }

        public void OnCollisionEnter(Collider other, string side)
        {
        }
    }
}