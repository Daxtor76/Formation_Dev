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
        public Vector2 gridSize = Vector2.Zero;
        Dictionary<Vector2, ILevelElement> grid = new Dictionary<Vector2, ILevelElement>();

        public Level(int sizeX, int sizeY)
        {
            gridSize = new Vector2(sizeX, sizeY);
        }

        public void GenerateGrid()
        {
            for (int i = 0; i < gridSize.X; i++)
            {
                for (int y = 0; y < gridSize.Y; y++)
                {
                    Array types = Enum.GetValues<Brick.BrickTypes>();
                    Array colors = Enum.GetValues<Brick.Colors>();
                    Random rand = new Random();

                    ILevelElement element;
                    if (rand.Next(0, 100) > 20.0f)
                        element = new NormalBrick((Brick.BrickTypes)types.GetValue(rand.Next(0, types.Length)), (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)), "Brick" + i + y);
                    else
                        element = new UnbreakableBrick((Brick.BrickTypes)types.GetValue(rand.Next(0, types.Length)), "Brick" + i + y);

                    float xPos = Utils.GetScreenCenter().X + element.GetSize().X * i - gridSize.X * element.GetSize().X * 0.5f;
                    float yPos = 50 + element.GetSize().Y * y;
                    element.SetPosition(new Vector2(xPos, yPos));

                    grid.Add(new Vector2(i, y), element);
                }
            }
        }

        public void Unload()
        {
            foreach (ILevelElement element in grid.Values)
            {
                element.Unload();
            }
        }
    }
}
