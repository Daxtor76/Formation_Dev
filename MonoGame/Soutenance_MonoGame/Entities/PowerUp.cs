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
            multiball,
            paddleScale,
            paddleSpeed
        }
        public enum PowerUpStates
        {
            Spawn,
            Idle
        }

        public PowerUpTypes type;
        public PowerUpStates state;
        public Collider col;
        public Mover mover;
        public Animator animator;
        public delegate void Effect(int amount = 0);
        public Effect powerUpEffect;

        public PowerUp(Vector2 pPos, PowerUpTypes pType)
        {
            Random rand = new Random();
            int rndNumber = rand.Next(0, 1000);

            type = pType;
            state = PowerUpStates.Spawn;
            SetName("PowerUp" + rndNumber.ToString());
            layer = "PowerUp";
            img = ServiceLocator.GetService<ISpritesManager>().GetPowerUpTexture($"powerup_{pType}_spritesheet");
            baseSize = new Vector2(30.0f, img.Height);
            size = baseSize * scale;
            position = new Vector2(pPos.X - size.X * 0.5f, pPos.Y - size.Y);

            switch (pType)
            {
                case PowerUpTypes.multiball:
                    powerUpEffect = MultiBallEffect;
                    break;
                case PowerUpTypes.paddleScale:
                    powerUpEffect = PaddleScaleEffect;
                    break;
                case PowerUpTypes.paddleSpeed:
                    powerUpEffect = PaddleSpeedEffect;
                    break;
            }

            col = new Collider(this, scale, OnCollisionEnter, OnCollision);
            mover = new Mover(100.0f);
            animator = new Animator(size);

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);

            Start();
        }

        public override void Start()
        {
            base.Start();

            Animation spawnAnim = new Animation(0, 5, 0.1f, false);
            Animation idleAnim = new Animation(6, 7, 0.1f, true);
            animator.anims.Add("Spawn", spawnAnim);
            animator.anims.Add("Idle", idleAnim);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            mover.Move(gameTime, this, new Vector2(0, 1), new Vector2(1, 1));

            if (animator.anims["Spawn"].isOver)
                state = PowerUpStates.Idle;

            sourceRect = animator.ReadAnim(gameTime, state.ToString());
        }

        public void PaddleSpeedEffect(int amount)
        {
            GameScene gameScene = ServiceLocator.GetService<ISceneManager>().GetCurrentScene() as GameScene;
            if (gameScene.paddle != null)
            {
                gameScene.paddle.mover.speed *= 1.25f;
            }
        }

        public void PaddleScaleEffect(int amount)
        {
            GameScene gameScene = ServiceLocator.GetService<ISceneManager>().GetCurrentScene() as GameScene;
            if (gameScene.paddle != null)
            {
                Vector2 currentPaddleScale = gameScene.paddle.scale;
                gameScene.paddle.SetScale(new Vector2(currentPaddleScale.X * 1.25f, currentPaddleScale.Y));
            }
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
                        Ball ball = new Ball(Ball.Colors.grey, 250.0f, "Ball" + rndNumber.ToString(), gameScene.mainBall.position, Ball.States.Boosted);
                        ball.mover.Launch(Utils.GetDirectionFromAngle(324 / (amount + 1) * (i + 1)), new Vector2(3.0f, 3.0f));
                    }
                }
            }
        }

        public void OnCollision(List<Collider> others)
        {
            foreach (Collider other in others)
            {
                if (!col.previousOthers.Contains(other.parent.GetName()))
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

        public override void Unload()
        {
            mover = null;

            animator.Unload();
            animator = null;

            powerUpEffect = null;

            base.Unload();
        }
    }
}
