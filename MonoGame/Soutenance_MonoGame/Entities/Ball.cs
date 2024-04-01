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
        Entity paddle;

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

            col = new Collider(this, OnCollisionEnter, OnCollision);
            mover = new Mover(pSpeed);
            paddle = ServiceLocator.GetService<IEntityManager>().GetEntity("Paddle");
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
                mover.ManageAccel(gameTime, new Vector2(5.0f, 5.0f));
                mover.Move(gameTime, this, mover.direction);

                canBeBoosted = GetDistance(paddle) <= paddle.size.X * 0.5f + size.X * 0.5f + 100.0f;
            }

            col.oldPosition = col.position;
        }

        public void OnCollisionEnter(Collider other)
        {
            string side = col.GetCollisionSide(other);

            CheckCollisionWithBottomWall(other, side);

            if (other.parent is IDamageable)
                Hit(other.parent as IDamageable);

            if (state == States.Normal || (state == States.Boosted && other.parent.layer != "Brick"))
            {
                ModifyDirection(other, side);

                if (other.parent.layer == "Wall" && side == "top")
                    state = States.Normal;
            }
        }

        void CheckCollisionWithBottomWall(Collider other, string side)
        {
            if (side == "bottom" && other.parent.layer == "Wall")
                LoseLife();

            return;
        }

        void LoseLife()
        {
            ServiceLocator.GetService<ISceneManager>().GetCurrentScene().state = SceneStates.Preparation;
            state = States.Normal;
            // TO DO: Ajouter ici la perte du vie du player
            // Check la defeat -> si == 0 game over sinon reset
            // Voir pour faire des unity event? avec un defeatManager qui regarde la vie du joueur et qui check quand la valeur change
        }

        void ModifyDirection(Collider other, string side)
        {
            if (other.parent.layer == "Paddle")
                CollidePaddle(other);
            else
                CollideOther(side);
        }

        void CollidePaddle(Collider other)
        {
            float modifier = GetImpactPointRelativePositionX(other.parent);
            mover.direction = Vector2.Normalize(new Vector2(modifier, -mover.direction.Y));

            if (state == States.Boosted)
            {
                mover.accel += new Vector2(1.0f, 1.0f);
            }
        }

        float GetImpactPointRelativePositionX(Entity target)
        {
            float ballCenterPos = position.X + size.X * 0.5f;
            float targetCenterPos = target.position.X + target.size.X * 0.5f;
            float targetSizeHalf = target.size.X * 0.5f;
            return -(targetCenterPos - ballCenterPos) / targetSizeHalf;
        }

        void CollideOther(string side)
        {
            if (side == "top")
                mover.direction.Y = 1;
            else if (side == "bottom")
                mover.direction.Y = -1;

            if (side == "left")
                mover.direction.X = 1;
            else if (side == "right")
                mover.direction.X = -1;

            mover.direction = Vector2.Normalize(mover.direction);
        }

        void Hit(IDamageable target)
        {
            target.TakeDamages(1);
        }

        public void OnCollision(Collider other)
        {
        }
    }
}
