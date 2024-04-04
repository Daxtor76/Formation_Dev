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
using static Soutenance_MonoGame.Scene;
using System.Threading;

namespace Soutenance_MonoGame
{
    public class Ball : Entity, ICollidable
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
        public enum States
        {
            Normal,
            Boosted
        }

        public States state;

        Collider col;
        public Mover mover;
        public Paddle paddle;

        public bool canBeBoosted = false;

        public Ball(Colors pColor, float pSpeed, string pName)
        {
            name = pName;
            layer = "Ball";
            img = ServiceLocator.GetService<ISpritesManager>().GetBallTexture("ball_" + pColor);
            size = new Vector2(img.Width, img.Height);
            position = GetSpawnPosition();

            state = States.Normal;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);

            col = new Collider(this, scale, OnCollisionEnter, OnCollision);
            mover = new Mover(pSpeed);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;

            if (ServiceLocator.GetService<ISceneManager>().GetCurrentScene().state == SceneStates.Preparation)
            {
                mover.FollowAbove(this, paddle);
            }
            else if (ServiceLocator.GetService<ISceneManager>().GetCurrentScene().state == SceneStates.Playing)
            {
                mover.Move(gameTime, this, mover.direction, new Vector2(5.0f, 5.0f));

                canBeBoosted = GetDistance(paddle) <= paddle.size.X * 0.5f + size.X * 0.5f + 100.0f;
            }

            col.oldPosition = col.position;
        }

        public void OnCollisionEnter(List<Collider> others)
        {
            Vector2 newDir = Vector2.Zero;

            foreach (Collider other in others)
            {
                if (!col.previousOthers.Contains(other.parent.name))
                {
                    string side = col.GetCollisionSide(other);

                    if (other.parent is IDamageable && other.parent.layer != "PowerUp")
                        Hit(other.parent as IDamageable);

                    if (other.parent.layer == "Paddle")
                    {
                        newDir = GetNewDirFromCollisionOnPaddle(other);
                        ActivateTeleporters();
                    }
                    else if (other.parent.layer == "Teleporter")
                        Teleport(other);
                    else if (other.parent.layer == "Wall")
                    {
                        if (side == "bottom")
                            LoseLife();

                        ActivateTeleporters();
                        newDir += GetNewDirFromCollision(side);
                        if (side == "top")
                            state = States.Normal;
                    }
                    else if (other.parent.layer == "Brick")
                    {
                        ActivateTeleporters();
                        if (state == States.Normal)
                            newDir += GetNewDirFromCollision(side);
                    }
                }
            }
            if (newDir != mover.direction && newDir != Vector2.Zero)
                Bounce(newDir);
        }

        void LoseLife()
        {
            ServiceLocator.GetService<ISceneManager>().GetCurrentScene().state = SceneStates.Preparation;
            state = States.Normal;
            return;
            // TO DO: Ajouter ici la perte du vie du player
            // Check la defeat -> si == 0 game over sinon reset
            // Voir pour faire des unity event? avec un defeatManager qui regarde la vie du joueur et qui check quand la valeur change
        }

        void Teleport(Collider other)
        {
            Teleporter tp = other.parent as Teleporter;
            Teleporter destTp = ServiceLocator.GetService<IEntityManager>().GetEntity(tp.destinationName) as Teleporter;
            destTp.col.active = false;
            position = destTp.position;
            mover.direction = Vector2.Normalize(destTp.newDirection);
        }

        void ActivateTeleporters()
        {
            foreach (Teleporter tp in ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<Teleporter>())
            {
                tp.col.active = true;
            }
        }

        Vector2 GetNewDirFromCollisionOnPaddle(Collider other)
        {
            float modifier = GetImpactPointRelativePositionX(other.parent);

            if (state == States.Boosted)
            {
                mover.accel += new Vector2(1.0f, 1.0f);
            }

            return new Vector2(modifier, -mover.direction.Y);
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
            }

            return dir;
        }

        void Bounce(Vector2 newDirection)
        {
            Debug.WriteLine(newDirection);
            mover.direction = Vector2.Normalize(newDirection);
        }

        void Hit(IDamageable target)
        {
            target.TakeDamages(1);
        }

        public void OnCollision(List<Collider> others)
        {
        }
    }
}
