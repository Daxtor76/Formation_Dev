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
using static Soutenance_MonoGame.Scene;
using System.Reflection.Metadata;
using static Soutenance_MonoGame.Ball;

namespace Soutenance_MonoGame
{
    public class Paddle : Entity, ICollidable
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
        Mover mover;
        public Ball ball;

        public Paddle(Colors pColor, float pSpeed, string pName)
        {
            name = pName;
            layer = "Paddle";
            img = ServiceLocator.GetService<ISpritesManager>().GetPaddleTexture("paddle_" + pColor);
            size = new Vector2(img.Width, img.Height);
            position = GetSpawnPosition();

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);

            col = new Collider(this, scale, OnCollisionEnter, OnCollision);
            mover = new Mover(pSpeed);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            if (ServiceLocator.GetService<IInputManager>().GetInputDirection() != Vector2.Zero)
            {
                mover.IncreaseAccelByDirection(gameTime, ServiceLocator.GetService<IInputManager>().GetInputDirection());
            }
            mover.MoveSmoothly(gameTime, this);

            if (ServiceLocator.GetService<ISceneManager>().GetCurrentScene().state == SceneStates.Preparation)
            {
                if (ServiceLocator.GetService<IInputManager>().KeyPressed(Keys.Space))
                {
                    LaunchBall(ball, new Vector2(0, -1));
                    ServiceLocator.GetService<ISceneManager>().GetCurrentScene().state = SceneStates.Playing;
                }
            }
            else if (ServiceLocator.GetService<ISceneManager>().GetCurrentScene().state == SceneStates.Playing)
            {
                if (ServiceLocator.GetService<IInputManager>().KeyPressed(Keys.Space))
                {
                    if (ball.canBeBoosted)
                    {
                        ball.state = States.Boosted;
                        Debug.WriteLine("BOOSTED");
                    }
                    else
                        Debug.WriteLine("raté");
                }
            }
        }

        public override Vector2 GetSpawnPosition()
        {
            Vector2 paddleSpawnPos = new Vector2();
            Vector2 screenSize = Utils.GetScreenSize();

            paddleSpawnPos.X = screenSize.X * 0.5f - size.X * 0.5f;
            paddleSpawnPos.Y = screenSize.Y - 50;

            return paddleSpawnPos;
        }

        public void OnCollisionEnter(Collider other)
        {
        }

        public void OnCollision(Collider other)
        {
        }

        void LaunchBall(Ball ball, Vector2 direction)
        {
            ball.mover.accel = new Vector2(5.0f, 5.0f);
            ball.mover.direction = direction;
        }
    }
}
