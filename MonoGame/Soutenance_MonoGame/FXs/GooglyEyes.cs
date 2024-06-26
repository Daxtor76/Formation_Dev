﻿using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using Vector2 = System.Numerics.Vector2;

namespace Soutenance_MonoGame
{
    public class GooglyEyes : Entity
    {
        Brick parent;
        Texture2D eye;
        Mover mover;
        int id;
        Vector2 eyePos;
        public GooglyEyes(Brick pParent, int pId)
        {
            Random rand = new Random();

            parent = pParent;
            SetName(pParent.GetName() + "googly" + rand.Next(0, 1000).ToString() + rand.Next(0, 1000).ToString() + rand.Next(0, 1000).ToString());
            layer = "FXs";
            img = ServiceLocator.GetService<ISpritesManager>().GetGooglyEyesTexture("background");
            eye = ServiceLocator.GetService<ISpritesManager>().GetGooglyEyesTexture("eye");
            baseSize = new Vector2(img.Width, img.Height);
            size = baseSize * scale;
            position = parent.GetCenterPosition();
            id = pId;
            eyePos = Vector2.Zero;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);

            mover = new Mover();
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            mover.Follow(this, parent, new Vector2(size.X * id - parent.life * size.X * 0.5f + size.X * 0.5f, 0.0f));
        }

        public override void Draw()
        {
            if (img != null)
            {
                Rectangle destRect = new Rectangle(
                    (int)position.X,
                    (int)position.Y,
                    (int)size.X,
                    (int)size.Y);
                MainGame.spriteBatch.Draw(img, destRect, sourceRect, Color.White, rotation, Vector2.Zero, SpriteEffects.None, parent.GetLayerDepth() + 0.001f);
                
            }

            if (eye != null)
            {
                GameScene gameScene = ServiceLocator.GetService<ISceneManager>().GetCurrentScene() as GameScene;
                Vector2 ballToEyeVector = Vector2.Zero;
                float distance = 0.0f;
                if (gameScene != null && gameScene.mainBall != null)
                {
                    ballToEyeVector = gameScene.mainBall.position - GetCenterPosition();
                    distance = 0.01f;
                }
                eyePos = position + ballToEyeVector * distance;

                Rectangle destRect = new Rectangle(
                    (int)eyePos.X,
                    (int)eyePos.Y,
                    (int)size.X,
                    (int)size.Y);
                MainGame.spriteBatch.Draw(eye, destRect, sourceRect, Color.White, rotation, Vector2.Zero, SpriteEffects.None, parent.GetLayerDepth() + 0.002f);
            }
        }

        public override void Unload()
        {
            mover = null;
            parent = null;

            base.Unload();
        }
    }
}
