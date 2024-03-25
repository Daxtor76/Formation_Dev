using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class Paddle : AbstractMoveable, ICollidable
    {
        public enum Colors
        {
            green,
            grey,
            orange,
            purple,
            red,
            yellow
        }
        Collider col;

        public Paddle(Colors pColor, float pSpeed, string pName) : base(pSpeed)
        {
            name = pName;
            layer = "Paddle";
            img = ServiceLocator.GetService<ISpritesManager>().GetPaddleTexture("paddle_" + pColor);
            size = new Vector2(img.Width, img.Height);
            position = GetSpawnPosition();
            targetPos = position;
            col = new Collider(this, OnCollisionEnter, OnCollision);

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public override void Update(GameTime gameTime)
        {
            direction = ServiceLocator.GetService<IInputManager>().GetInputDirection();
            base.Update(gameTime);
        }
        public override Vector2 GetSpawnPosition()
        {
            Vector2 paddleSpawnPos = new Vector2();
            Vector2 screenSize = Utils.GetScreenSize();

            paddleSpawnPos.X = screenSize.X * 0.5f - size.X * 0.5f;
            paddleSpawnPos.Y = screenSize.Y - 50;

            return paddleSpawnPos;
        }

        public override void Move(GameTime gameTime)
        {
            Vector2 screenSize = Utils.GetScreenSize();
            targetPos += speed * direction * (float)gameTime.ElapsedGameTime.TotalSeconds;
            targetPos = new Vector2(Math.Clamp(targetPos.X, 0, screenSize.X - size.X), targetPos.Y);

            position = Vector2.Lerp(position, targetPos, 0.1f);
        }

        public void OnCollisionEnter(Collider other)
        {
        }

        public void OnCollision(Collider other)
        {
        }
    }
}
