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

        Collider col;
        Mover mover;

        Entity paddle = ServiceLocator.GetService<IEntityManager>().GetEntity("Paddle") as Paddle;

        public Ball(Colors pColor, float pSpeed, string pName)
        {
            name = pName;
            layer = "Ball";
            img = ServiceLocator.GetService<ISpritesManager>().GetBallTexture("ball_" + pColor);
            size = new Vector2(img.Width, img.Height);
            position = GetSpawnPosition();

            mover = new Mover(pSpeed);
            col = new Collider(this, OnCollisionEnter, OnCollision);

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            if (ServiceLocator.GetService<ISceneManager>().GetCurrentScene().state == SceneStates.Preparation)
            {
                position = mover.Follow(size, paddle);
                if (ServiceLocator.GetService<IInputManager>().IsPressedOnce(Keys.Space))
                {
                    Launch();
                    ServiceLocator.GetService<ISceneManager>().GetCurrentScene().state = SceneStates.Playing;
                }
            }
            else if (ServiceLocator.GetService<ISceneManager>().GetCurrentScene().state == SceneStates.Playing)
            {
                position = mover.Move(gameTime, position, size, mover.direction);
            }

            col.oldPosition = col.position;
        }

        public void OnCollisionEnter(Collider other)
        {
            string side = col.GetCollisionSide(other);

            CheckCollisionWithBottomWall(other, side);
            Hit(other.parent as IDamageable);
            ModifyDirection(col.others, side);
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
            // TO DO: Ajouter ici la perte du vie du player
            // Check la defeat -> si == 0 game over sinon reset
            // Voir pour faire des unity event? avec un defeatManager qui regarde la vie du joueur et qui check quand la valeur change
        }

        void ModifyDirection(List<Collider> others, string side)
        {
            foreach (Collider other in others)
            {
                if (other.parent.layer == "Paddle")
                    CollidePaddle(other);
                else
                    CollideOther(side);
            }
        }

        void CollidePaddle(Collider other)
        {
            float modifier = GetImpactPointRelativePositionX(other.parent);
            mover.direction = Vector2.Normalize(new Vector2(modifier, -mover.direction.Y));
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
            if (target is IDamageable)
                target.TakeDamages(1);
        }

        void Launch()
        {
            mover.direction = new Vector2(0, -1);
        }

        public void OnCollision(Collider other)
        {
        }
    }
}
