using Microsoft.Xna.Framework;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Drawing;

namespace Soutenance_MonoGame
{
    public class PowerUp : Entity, ICollidable
    {
        public enum PowerUpTypes
        {
            multiball
        }

        public PowerUpTypes type;
        public Collider col;
        public Mover mover;
        public delegate void Effect(int amount = 0);
        public Effect powerUpEffect;

        public PowerUp(Vector2 pPos, PowerUpTypes pType)
        {
            Random rand = new Random();
            int rndNumber = rand.Next(0, 1000);

            type = pType;
            name = "PowerUp" + rndNumber.ToString();
            layer = "PowerUp";
            img = ServiceLocator.GetService<ISpritesManager>().GetPowerUpTexture($"powerup_{pType}_spritesheet");
            size = new Vector2(30.0f, img.Height);
            position = new Vector2(pPos.X - size.X * 0.5f, pPos.Y - size.Y);

            switch (pType)
            {
                case PowerUpTypes.multiball:
                    powerUpEffect = MultiBallEffect;
                    break;
            }

            col = new Collider(this, scale, OnCollisionEnter, OnCollision);
            mover = new Mover(100.0f);

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            mover.Move(gameTime, this, new Vector2(0, 1), new Vector2(1, 1));
        }

        public void MultiBallEffect(int amount)
        {
            GameScene gameScene = ServiceLocator.GetService<ISceneManager>().GetCurrentScene() as GameScene;
            if (gameScene.mainBall != null)
            {
                if (gameScene.mainBall.state != Ball.States.Preparation)
                {
                    Array colors = Enum.GetValues<Ball.Colors>();
                    Random rand = new Random();

                    for (int i = 0; i < amount; i++)
                    {
                        int rndNumber = rand.Next(0, 1000);
                        Ball ball = new Ball(Ball.Colors.grey, 350.0f, "Ball" + rndNumber.ToString(), gameScene.mainBall.position, Ball.States.Boosted);
                        ball.mover.Launch(Utils.GetDirectionFromAngle(324 / (amount + 1) * (i + 1)), new Vector2(3.0f, 3.0f));
                    }
                }
            }
        }

        public void OnCollision(List<Collider> others)
        {
            foreach (Collider other in others)
            {
                if (!col.previousOthers.Contains(other.parent.name))
                {
                    string side = col.GetCollisionSide(other);
                    if (other.parent.layer == "Wall")
                    {
                        if (side == "bottom")
                            Destroy();
                    }
                    else if (other.parent.layer == "Paddle")
                    {
                        powerUpEffect(3);
                        Destroy();
                    }
                }
            }
        }

        public void OnCollisionEnter(List<Collider> others)
        {
        }
    }
}
