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

        public void GenerateGrid()
        {
            Array colors = Enum.GetValues<Brick.Colors>();
            Random rand = new Random();
            for (int i = 0; i < levelElements.Count; i++)
            {
                IEntity element = null;
                string elementType = levelElements[i]["class"].ToString();
                Vector2 elementPosition = new Vector2(int.Parse(levelElements[i]["posX"].ToString()), int.Parse(levelElements[i]["posY"].ToString()));
                switch (elementType)
                {
                    case "unbreakable":
                        element = new BrickUnbreakable(
                            levelElements[i]["type"].ToString(),
                            Brick.Colors.grey,
                            levelElements[i]["name"].ToString(),
                            elementPosition);
                        break;
                    case "powerup":
                        element = new BrickPowerUp(
                            levelElements[i]["type"].ToString(),
                            (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)),
                            levelElements[i]["name"].ToString(),
                            elementPosition);
                        break;
                    case "normal":
                        element = new BrickNormal(
                            levelElements[i]["type"].ToString(),
                            (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)),
                            levelElements[i]["name"].ToString(),
                            elementPosition);
                        break;
                    case "moving":
                        element = new BrickMoving(
                            levelElements[i]["type"].ToString(),
                            (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)),
                            levelElements[i]["name"].ToString(),
                            new Vector2(rand.Next(-300, 300), 0.0f),
                            elementPosition);
                        break;
                    case "teleporter":
                        Vector2 elementNewDirection = new Vector2(int.Parse(levelElements[i]["newDirectionX"].ToString()), int.Parse(levelElements[i]["newDirectionY"].ToString()));
                        JsonNode othersElements = levelElements[i]["othersToActivate"];
                        List<string> others = new List<string>();
                        for (int y = 0; y < othersElements.AsObject().Count; y++)
                        {
                            others.Add(othersElements[y.ToString()].ToString());
                        }
                        element = new Teleporter(
                            elementPosition,
                            (float)levelElements[i]["rotation"],
                            levelElements[i]["destinationName"].ToString(),
                            elementNewDirection,
                            levelElements[i]["name"].ToString(),
                            (bool)levelElements[i]["active"],
                            others);
                        ;
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
