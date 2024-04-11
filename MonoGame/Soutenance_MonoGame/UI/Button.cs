using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
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
    public class Button : Entity
    {
        public enum Colors
        {
            blue,
            green
        }
        public delegate void Effect();

        Effect onClick;
        Text text;

        public Button(Vector2 pPosition, Colors pColor, string pName, string pTextValue, Text.FontType pFontType, Color pTextColor, Effect onClickEffect)
        {
            SetName(pName);
            layer = "UI";
            position = pPosition;
            img = ServiceLocator.GetService<ISpritesManager>().GetButtonTexture("button_" + pColor);
            baseSize = new Vector2(img.Width, img.Height);
            size = baseSize * scale;
            onClick = onClickEffect;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);

            text = new Text(pPosition - GetSize() * 0.25f, pTextValue, pName + "text", pFontType, pTextColor, this);
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            if (IsHover())
            {
                OnHover();

                if (ServiceLocator.GetService<IInputManager>().MouseKeyPressed(0))
                    onClick();
            }
            else
                OnNotHover();
        }

        public override void Draw()
        {
            if (img != null)
            {
                Rectangle destRect = new Rectangle(
                    (int)GetPosition().X,
                    (int)GetPosition().Y,
                    (int)GetSize().X,
                    (int)GetSize().Y);
                MainGame.spriteBatch.Draw(img, destRect, sourceRect, Color.White, rotation, GetSize() * 0.25f, SpriteEffects.None, 0.0f);
            }
        }

        public bool IsHover()
        {
            return Utils.GetMousePosition().X < GetPosition().X + GetSize().X * 0.75f &&
            Utils.GetMousePosition().X > GetPosition().X - GetSize().X * 0.25f &&
            Utils.GetMousePosition().Y < GetPosition().Y + GetSize().Y * 0.75f &&
            Utils.GetMousePosition().Y > GetPosition().Y - GetSize().Y * 0.25f;
        }

        public void OnHover()
        {
            SetScale(new Vector2(0.95f, 0.95f));
        }

        public void OnNotHover()
        {
            SetScale(new Vector2(1.0f, 1.0f));
        }
    }
}
