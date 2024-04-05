using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class Level
    {
        public Vector2 gridSize = Vector2.Zero;
        public List<Teleporter> teleporters;
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

                    float randNb = rand.Next(0, 100);
                    if (randNb >= 25.0f)
                        element = new BrickNormal((Brick.BrickTypes)types.GetValue(rand.Next(0, types.Length - 1)), (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)), "Brick" + i + y);
                    else if (randNb < 25.0f && randNb >= 20.0f)
                        element = new BrickUnbreakable((Brick.BrickTypes)types.GetValue(rand.Next(0, types.Length - 1)), Brick.Colors.grey, "Brick" + i + y);
                    else if (randNb < 20.0f && randNb >= 10.0f)
                        element = new BrickMoving((Brick.BrickTypes)types.GetValue(rand.Next(0, types.Length - 1)), (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)), "Brick" + i + y, new Vector2(rand.Next(-300, 300), 0.0f));
                    else
                        element = new BrickPowerUp(Brick.BrickTypes.powerupbrick, (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)), "Brick" + i + y);

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
