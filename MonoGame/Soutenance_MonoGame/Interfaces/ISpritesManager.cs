using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public interface ISpritesManager
    {
        public Texture2D GetPaddleTexture(string textureName);
        public Texture2D GetBallTexture(string textureName);
        public Texture2D GetBrickTexture(string textureName);
        public Texture2D GetPortalTexture();
    }
}
