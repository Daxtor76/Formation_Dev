using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using ProjectTemplate.Controllers;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjectTemplate.Constructors
{
    public class MoveableObject : Entity
    {
        public Texture2D img;
        public Collider col;

        public MoveableObject(MainGame pProjectGame, Texture2D pImg, Vector2 pPos, string pName, string pLayer) : base(pProjectGame)
        {
            name = pName;
            layer = pLayer;
            projectGame = pProjectGame;
            position = pPos;
            img = pImg;
            size = new Vector2(img.Width, img.Height);
            col = new Collider(pProjectGame, this, OnHit);

            EntityController.entities.Add(this);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            Move(gameTime);
        }

        public override void Draw(GameTime gameTime)
        {
            base.Draw(gameTime);
            projectGame._spriteBatch.Draw(img, position, Color.White);
        }

        void OnHit()
        {
            Debug.WriteLine("Hit");
        }

        public virtual void Move(GameTime gameTime)
        {
            position += 200 * GetMovementDirection() * (float)gameTime.ElapsedGameTime.TotalSeconds;
            position.X = Math.Clamp(position.X, 0, 800 - size.X);
            position.Y = Math.Clamp(position.Y, 0, 500 - size.Y);
        }

        Vector2 GetMovementDirection()
        {
            Vector2 direction = new Vector2();

            if (Keyboard.GetState().IsKeyDown(Keys.D))
                direction.X = 1;
            else if (Keyboard.GetState().IsKeyDown(Keys.Q))
                direction.X = -1;

            if (Keyboard.GetState().IsKeyDown(Keys.Z))
                direction.Y = -1;
            else if (Keyboard.GetState().IsKeyDown(Keys.S))
                direction.Y = 1;

            return direction;
        }
    }
}
