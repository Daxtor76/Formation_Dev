using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class Heart : Entity
    {
        public Heart()
        {
            Random rand = new Random();
            int rndNumber = rand.Next(0, 1000);

            SetName("heart" + rndNumber.ToString());
            layer = "FXs";
            img = ServiceLocator.GetService<ISpritesManager>().GetBallTexture("ball_red");
            baseSize = new Vector2(img.Width, img.Height);
            size = baseSize * scale;

            ServiceLocator.GetService<IEntityManager>().AddEntity(this);
        }
    }
}
