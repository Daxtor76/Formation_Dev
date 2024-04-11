using Microsoft.Xna.Framework;
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
    public class Text : Entity
    {
        public enum FontType
        {
            normal,
            big
        }

        Entity parent;
        SpriteFont font;
        string value;
        Color textColor;

        public Text(Vector2 pPosition, string pValue, string pName, FontType pFontType, Color pColor, Entity pParent = null)
        {
            SetName(pName);
            layer = "UI";
            value = pValue;
            textColor = pColor;
            parent = pParent;

            switch (pFontType)
            {
                case FontType.normal:
                    font = MainGame.content.Load<SpriteFont>("UI/Fonts/normalFont");
                    break;
                case FontType.big:
                    font = MainGame.content.Load<SpriteFont>("UI/Fonts/bigFont");
                    break;
            }
            baseSize = new Vector2(font.MeasureString(value).X, font.MeasureString(value).Y);
            size = baseSize * scale;

            if (parent != null)
                position = pPosition + parent.GetSize() * 0.5f;
            else
                position = pPosition - GetSize() * 0.5f;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }
        public override void Draw()
        {
            if (parent != null)
                MainGame.spriteBatch.DrawString(font, value, position, textColor, 0.0f, GetSize() * 0.5f, parent.scale, SpriteEffects.None, 0.0f);
            else
                MainGame.spriteBatch.DrawString(font, value, position, textColor);
        }
    }
}
