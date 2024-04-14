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
using System.Drawing;
using System.ComponentModel.Design;
using System.Threading;
using static System.Net.Mime.MediaTypeNames;

namespace Soutenance_MonoGame
{
    public class Ball : Entity, ICollidable
    {
        public enum Colors
        {
            grey,
            red,
        }
        public enum States
        {
            Preparation,
            Normal,
            Boosted
        }

        public States state;

        Collider col;
        public Mover mover;
        public Animator animator;

        public bool canBeBoosted = false;

        public Ball(float pSpeed, string pName)
        {
            SetName(pName);
            layer = "Ball";
            img = ServiceLocator.GetService<ISpritesManager>().GetBallTexture("ball_" + Colors.red + "_spritesheet");
            baseSize = new Vector2(26.0f, img.Height);
            size = baseSize * scale;
            position = GetSpawnPosition();
            state = States.Preparation;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);

            col = new Collider(this, scale, OnCollisionEnter, OnCollision);
            mover = new Mover(pSpeed);
            animator = new Animator(size);

            Start();
        }

        public Ball(Colors pColor, float pSpeed, string pName, Vector2 pPosition, States pState)
        {
            SetName(pName);
            layer = "Ball";
            img = ServiceLocator.GetService<ISpritesManager>().GetBallTexture("ball_" + pColor + "_spritesheet");
            baseSize = new Vector2(26.0f, img.Height);
            size = baseSize * scale;
            position = pPosition;

            state = pState;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);

            col = new Collider(this, scale, OnCollisionEnter, OnCollision);
            mover = new Mover(pSpeed);
            animator = new Animator(size);

            Start();
        }

        public override void Start()
        {
            base.Start();

            Animation preparationAnim = new Animation(0, 0, 0.1f, true);
            Animation idleAnim = new Animation(0, 3, 0.2f, true);
            Animation boostedAnim = new Animation(4, 7, 0.1f, true);
            animator.anims.Add(States.Preparation.ToString(), preparationAnim);
            animator.anims.Add(States.Normal.ToString(), idleAnim);
            animator.anims.Add(States.Boosted.ToString(), boostedAnim);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;
            Paddle paddle = ServiceLocator.GetService<IEntityManager>().GetEntity("Paddle") as Paddle;

            if (state == States.Preparation)
            {
                mover.FollowAbove(this, paddle);

                if (ServiceLocator.GetService<IInputManager>().KeyPressed(Keys.Space))
                {
                    mover.Launch(new Vector2(0, -1), new Vector2(3.0f, 3.0f));
                    state = States.Normal;
                }
            }
            else if (state == States.Normal || state == States.Boosted)
            {
                mover.Move(gameTime, this, mover.direction, new Vector2(5.0f, 5.0f));

                if (ServiceLocator.GetService<IInputManager>().KeyPressed(Keys.Space))
                {
                    canBeBoosted = GetDistance(paddle) <= paddle.size.X * 0.5f + size.X * 0.5f + 100.0f;

                    if (canBeBoosted)
                    {
                        state = States.Boosted;
                        Debug.WriteLine("BOOSTED");
                    }
                    else
                        Debug.WriteLine("raté");
                }
            }

            sourceRect = animator.ReadAnim(gameTime, state.ToString());
            col.oldPosition = col.position;
        }

        public void OnCollisionEnter(List<Collider> others)
        {
            Vector2 newDir = Vector2.Zero;
            if (others.Count > 1)
            {
                Debug.WriteLine(newDir);
            }

            foreach (Collider other in others)
            {
                if (!col.previousOthers.Contains(other.parent.GetName()))
                {
                    string side = col.GetCollisionSide(other);

                    if (other.parent.layer == "Paddle")
                    {
                        newDir = GetNewDirFromCollisionOnPaddle(other);
                        ActivateTeleportersColliders();
                    }
                    else if (other.parent.layer == "Teleporter")
                    {
                        Teleporter tp = ServiceLocator.GetService<IEntityManager>().GetEntity(other.parent.GetName()) as Teleporter;
                        Teleporter destTp = ServiceLocator.GetService<IEntityManager>().GetEntity(tp.destinationName) as Teleporter;
                        Teleport(destTp);
                        newDir = GetNewDirFromTeleport(destTp);
                    }
                    else if (other.parent.layer == "Wall")
                    {
                        if (side == "bottom")
                        {
                            Destroy();
                            return;
                        }

                        ActivateTeleportersColliders();

                        newDir += GetNewDirFromCollision(side);
                        if (newDir == Vector2.Zero)
                            newDir = -mover.direction;

                        if (side == "top")
                            state = States.Normal;
                    }
                    else if (other.parent.layer == "Brick")
                    {
                        ActivateTeleportersColliders();

                        if (state == States.Normal)
                        {
                            newDir += GetNewDirFromCollision(side);

                            if (newDir == Vector2.Zero)
                                newDir = -mover.direction;
                        }
                    }

                    if (other.parent is IDamageable)
                        Hit(other.parent as IDamageable);
                }
            }

            if (newDir != Vector2.Zero)
                Bounce(newDir);
        }

        void Teleport(Teleporter destination)
        {
            destination.col.SetActive(false);
            SetPosition(destination.position);
        }

        void ActivateTeleportersColliders()
        {
            foreach (Teleporter tp in ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<Teleporter>())
            {
                if (tp.IsActive())
                    tp.col.SetActive(true);
            }
        }

        Vector2 GetNewDirFromTeleport(Teleporter other)
        {
            return other.GetNewDirection();
        }

        Vector2 GetNewDirFromCollisionOnPaddle(Collider other)
        {
            float modifier = GetImpactPointRelativePositionX(other.parent);

            if (state == States.Boosted)
                mover.accel += new Vector2(1.0f, 1.0f);

            return new Vector2(modifier, -1.0f);
        }

        float GetImpactPointRelativePositionX(Entity target)
        {
            float ballCenterPos = position.X + size.X * 0.5f;
            float targetCenterPos = target.position.X + target.size.X * 0.5f;
            float targetSizeHalf = target.size.X * 0.5f;
            return -(targetCenterPos - ballCenterPos) / targetSizeHalf;
        }

        Vector2 GetNewDirFromCollision(string side)
        {
            Vector2 dir = Vector2.Zero;

            switch (side)
            {
                case "top":
                    dir = new Vector2(mover.direction.X, -mover.direction.Y);
                    break;
                case "right":
                    dir = new Vector2(-mover.direction.X, mover.direction.Y);
                    break;
                case "bottom":
                    dir = new Vector2(mover.direction.X, -mover.direction.Y);
                    break;
                case "left":
                    dir = new Vector2(-mover.direction.X, mover.direction.Y);
                    break;
                default:
                    dir = new Vector2(mover.direction.X, mover.direction.Y);
                    break;
            }

            return dir;
        }

        void Bounce(Vector2 newDirection)
        {
            GameScene gameScene = ServiceLocator.GetService<ISceneManager>().GetCurrentScene() as GameScene;
            gameScene.victoryManager.AddBounce(1);

            mover.direction = Vector2.Normalize(newDirection);
        }

        void Hit(IDamageable target)
        {
            target.TakeDamages(1);
        }

        public void OnCollision(List<Collider> others)
        {
        }

        public override void Unload()
        {
            mover = null;
            animator = null;

            SetEnabled(false);
        }
    }
}
