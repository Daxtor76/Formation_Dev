using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Soutenance_MonoGame.Interfaces;
using System.Drawing;

namespace Soutenance_MonoGame
{
    public class Ball : AbstractMoveable, ICollidable
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

        public Ball(Colors pColor, float pSpeed, Vector2 pDirection, string pName) : base(pSpeed, pDirection)
        {
            name = pName;
            layer = "Ball";
            img = ServiceLocator.GetService<ISpritesManager>().GetBallTexture("ball_" + pColor);
            size = new Vector2(img.Width, img.Height);
            position = GetSpawnPosition();
            col = new Collider(this, OnCollisionEnter, OnCollision);

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            // TO DO: voir si on peut pas ranger ça ailleurs
            col.oldPosition = col.position;
        }

        public void OnCollisionEnter(Collider other)
        {
            string side = col.GetCollisionSide(other);

            CheckCollisionWithBottomWall(other, side);
            Hit(other.parent as IDamageable);
            ModifyDirection(other, side);
        }

        void CheckCollisionWithBottomWall(Collider other, string side)
        {
            if (side == "bottom" && other.parent.layer == "Wall")
                LoseLife();

            return;
        }

        void LoseLife()
        {
            position = Utils.GetScreenCenter();
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
            direction = Vector2.Normalize(new Vector2(modifier, -direction.Y));
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
            if (side == "top" || side == "bottom")
                direction.Y = -direction.Y;
            else if (side == "left" || side == "right")
                direction.X = -direction.X;
        }

        void Hit(IDamageable target)
        {
            if (target is IDamageable)
                target.TakeDamages(1);
        }

        public void OnCollision(Collider other)
        {
        }
    }
}
