using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class Level
    {
        Dictionary<Vector2, ILevelElement> grid = new Dictionary<Vector2, ILevelElement>();
        Vector2 gridInitPosition = new Vector2(50, 50);

        public Level(int sizeX, int sizeY)
        {
            grid = GenerateGrid(sizeX, sizeY);
        }

        public Dictionary<Vector2, ILevelElement> GenerateGrid(int sizeX, int sizeY)
        {
            Dictionary<Vector2, ILevelElement> dico = new Dictionary<Vector2, ILevelElement>();

            for (int i = 0; i < sizeX; i++)
            {
                for (int y = 0; y < sizeY; y++)
                {
                    Array types = Enum.GetValues<Brick.BrickTypes>();
                    Array colors = Enum.GetValues<Brick.Colors>();
                    Random rand = new Random();

                    ILevelElement element = new Brick((Brick.BrickTypes)types.GetValue(rand.Next(0, types.Length)), (Brick.Colors)colors.GetValue(rand.Next(0, colors.Length)), "Brick" + i + y);

                    float xPos = Utils.GetScreenCenter().X + element.GetSize().X * i - sizeX * element.GetSize().X * 0.5f;
                    float yPos = 50 + element.GetSize().Y * y;
                    element.SetPosition(new Vector2(xPos, yPos));
                }
            }

            return dico;
        }

        public void Unload()
        {

        }
    }
}
