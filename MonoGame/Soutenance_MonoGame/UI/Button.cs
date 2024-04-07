using Microsoft.Xna.Framework;
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
    public class Button : Entity
    {
        public enum Colors
        {
            blue,
            green
        }
        public enum ButtonStates
        {
            idle,
            hover
        }
        public delegate void Effect();

        Effect onClick;
        ButtonStates state;

        public Button(Vector2 pPosition, Colors pColor, string pName, Effect onClickEffect)
        {
            SetName(pName);
            layer = "Ball";
            position = pPosition;
            img = ServiceLocator.GetService<ISpritesManager>().GetButtonTexture("button_" + pColor);
            baseSize = new Vector2(img.Width, img.Height);
            scale = new Vector2(0.4f, 0.4f);
            size = baseSize * scale;
            onClick = onClickEffect;
            state = ButtonStates.idle;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }

        public override void Start()
        {
            base.Start();
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
        }

        // Check position de la souris
        // Refaire les collisions ici

    }
}
