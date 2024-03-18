using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame.Interfaces
{
    public interface ISpritesManager
    {
        public List<Texture2D> LoadPaddleTextures();
        public List<Texture2D> LoadBallTextures();
        public Texture2D GetPaddleTexture(int id);
        public Texture2D GetBallTexture(int id);
    }
}
