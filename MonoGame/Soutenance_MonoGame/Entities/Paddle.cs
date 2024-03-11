﻿using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Vector2 = System.Numerics.Vector2;
using Soutenance_MonoGame.Constructors;
using Soutenance_MonoGame.Controllers;
using Soutenance_MonoGame.Interfaces;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Soutenance_MonoGame.Entities.Brick;

namespace Soutenance_MonoGame.Entities
{
    public class Paddle : AbstractMoveable, ICollidable
    {
        public enum Colors
        {
            grey,
            green,
            yellow,
            orange,
            red,
            purple
        }
        Collider col;
        Colors paddleColor;

        public Paddle(Colors pColor, float pSpeed, string pName) : base(pSpeed)
        {
            name = pName;
            layer = "Paddle";
            paddleColor = pColor;
            img = MainGame._content.Load<Texture2D>($"Paddle/paddle_{paddleColor}");
            size = new Vector2(img.Width, img.Height);
            position = GetSpawnPosition();
            col = new Collider(this, OnCollisionEnter, OnCollision);

            EntityController.entities.Add(this);
        }

        public override void Update(GameTime gameTime)
        {
            direction = GetInputDirection();
            base.Update(gameTime);
        }
        public override Vector2 GetSpawnPosition()
        {
            Vector2 paddleSpawnPos = new Vector2();

            paddleSpawnPos.X = MainGame._graphics.PreferredBackBufferWidth * 0.5f - size.X * 0.5f;
            paddleSpawnPos.Y = MainGame._graphics.PreferredBackBufferHeight - MainGame._graphics.PreferredBackBufferHeight * 0.05f - size.Y * 0.5f;

            return paddleSpawnPos;
        }

        public void OnCollisionEnter(Collider other, string side)
        {
        }

        public void OnCollision(Collider other, string side)
        {
        }
    }
}
