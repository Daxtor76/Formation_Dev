using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
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
            int rndNumber = rand.Next(0, 1000);

            parent = pParent;
            name = pParent.name + "googly" + rndNumber.ToString();
            layer = "FXs";
            img = ServiceLocator.GetService<ISpritesManager>().GetGoogleEyesTexture("background");
            eye = ServiceLocator.GetService<ISpritesManager>().GetGoogleEyesTexture("eye");
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
            base.Draw();
            if (eye != null)
            {
                GameScene gameScene = ServiceLocator.GetService<ISceneManager>().GetCurrentScene() as GameScene;
                if (gameScene.mainBall != null)
                {
                    Vector2 ballToEyeVector = gameScene.mainBall.position - GetCenterPosition();
                    float distance = 0.01f;
                    eyePos = position + ballToEyeVector * distance;
                }

                Rectangle destRect = new Rectangle(
                    (int)eyePos.X,
                    (int)eyePos.Y,
                    (int)size.X,
                    (int)size.Y);
                MainGame.spriteBatch.Draw(eye, destRect, sourceRect, Color.White, rotation, Vector2.Zero, SpriteEffects.None, 0.0f);
            }
        }
    }
}
