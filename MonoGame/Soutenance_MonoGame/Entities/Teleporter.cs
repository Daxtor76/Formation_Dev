﻿using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Vector2 = System.Numerics.Vector2;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class Teleporter : Entity, ICollidable
    {
        public string destinationName;
        public Vector2 newDirection;
        public Collider col;
        public List<string> othersToActivate;
        Animator animator;
        public Teleporter(Vector2 pPos, float pRotation, string pdestinationName, Vector2 pNewDirection, string pName, bool pActive, List<string> pOthersToActivate = null)
        {
            SetName(pName);
            layer = "Teleporter";
            img = ServiceLocator.GetService<ISpritesManager>().GetPortalTexture();
            baseSize = new Vector2(53.3f, 92.0f);
            size = baseSize * scale;
            position = pPos;
            rotation = pRotation;
            SetActive(pActive);
            destinationName = pdestinationName;
            newDirection = pNewDirection;

            othersToActivate = pOthersToActivate;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);

            col = new Collider(this, new Vector2(0.5f, 0.5f), OnCollisionEnter, OnCollision);
            animator = new Animator(size);

            Start();
        }

        public override void Start()
        {
            base.Start();

            Animation idleAnim = new Animation(0, 5, 0.4f, true);
            animator.anims.Add("Idle", idleAnim);
        }

        public override void Update(GameTime gameTime)
        {
            sourceRect = animator.ReadAnim(gameTime, "Idle");
        }

        public override void Draw()
        {
            if (img != null)
            {
                Rectangle destRect = new Rectangle(
                    (int)(position.X + size.X * 0.5f),
                    (int)(position.Y + size.Y * 0.5f),
                    (int)size.X,
                    (int)size.Y);
                MainGame.spriteBatch.Draw(img, destRect, sourceRect, Color.White, rotation, new Vector2(size.X * 0.5f, size.Y * 0.5f), SpriteEffects.None, 1.0f);
            }
        }

        public void OnCollision(List<Collider> others)
        {
        }

        public void OnCollisionEnter(List<Collider> others)
        {
            foreach (Collider other in others)
            {
                if (other.parent.layer == "Ball")
                {
                    if (othersToActivate != null)
                    {
                        ActivateOthers();
                        SetActive(false);
                        col.SetActive(false);
                    }
                }
            }
        }

        public void ActivateOthers()
        {
            foreach (string tpName in othersToActivate)
            {
                Teleporter tp = ServiceLocator.GetService<IEntityManager>().GetEntity(tpName) as Teleporter;
                tp.SetActive(true);
                tp.col.SetActive(true);
            }
        }

        public override void Unload()
        {
            othersToActivate.Clear();

            animator.Unload();
            animator = null;

            base.Unload();
        }
    }
}
