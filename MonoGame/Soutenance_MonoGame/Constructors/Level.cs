using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Text.Json.Nodes;
using System.Threading;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Soutenance_MonoGame
{
    public class Level
    {
        List<JsonNode> levelElements = new List<JsonNode>();
        List<IEntity> elements = new List<IEntity>();

        public Level(List<JsonNode> pLevelElements)
        {
            levelElements = pLevelElements;
        }

        public List<JsonNode> GetLevelElements()
        {
            return levelElements;
        }

        public void GenerateGrid()
        {
            Array colors = Enum.GetValues<Brick.Colors>();
            Random rand = new Random();
            for (int i = 0; i < levelElements.Count; i++)
            {
                IEntity element = null;
                string elementType = levelElements[i]["class"].ToString();
                Vector2 elementPosition = new Vector2((float)levelElements[i]["posX"], (float)levelElements[i]["posY"]);
                switch (elementType)
                {
                    case "BrickUnbreakable":
                        element = new BrickUnbreakable(
                            levelElements[i]["type"].ToString(),
                            Brick.Colors.grey,
                            i.ToString() + rand.Next(0, 1000) + rand.Next(0, 1000),
                            elementPosition);
                        break;
                    case "BrickPowerUp":
                        element = new BrickPowerUp(
                            levelElements[i]["type"].ToString(),
                            (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)),
                            i.ToString() + rand.Next(0, 1000) + rand.Next(0, 1000),
                            elementPosition);
                        break;
                    case "BrickNormal":
                        element = new BrickNormal(
                            levelElements[i]["type"].ToString(),
                            (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)),
                            i.ToString() + rand.Next(0, 1000) + rand.Next(0, 1000),
                            elementPosition);
                        break;
                    case "BrickMoving":
                        element = new BrickMoving(
                            levelElements[i]["type"].ToString(),
                            (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)),
                            i.ToString() + rand.Next(0, 1000) + rand.Next(0, 1000),
                            new Vector2(rand.Next(-200, 200), 0.0f),
                            elementPosition);
                        break;
                    case "Teleporter":
                        Vector2 elementNewDirection = new Vector2((float)levelElements[i]["newDirectionX"], (float)levelElements[i]["newDirectionY"]);
                        element = new Teleporter(
                            elementPosition,
                            (float)levelElements[i]["rotation"],
                            "",
                            elementNewDirection,
                            i.ToString() + rand.Next(0, 1000) + rand.Next(0, 1000),
                            true);
                        break;
                    default:
                        break; 
                }
                Debug.WriteLine($"Generate Element : {element.GetName()} at {element.GetPosition()}");
                element.SetLayerDepth(i * 0.01f);
                element.Start();

                elements.Add(element);
            }
        }

        public void Unload()
        {
            elements.Clear();
        }
    }
}
