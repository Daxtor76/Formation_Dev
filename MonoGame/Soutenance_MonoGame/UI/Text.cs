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

        SpriteFont font;
        string value;
        Color textColor;

        public Text(Vector2 pPosition, string pValue, string pName, FontType pFontType, Color pColor)
        {
            SetName(pName);
            layer = "UI";
            value = pValue;
            textColor = pColor;

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
            position = pPosition - size * 0.5f;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public override void Start()
        {
            base.Start();
        }

        public override void Draw()
        {
            base.Draw();

            MainGame.spriteBatch.DrawString(font, value, position, textColor);
        }
    }
}
