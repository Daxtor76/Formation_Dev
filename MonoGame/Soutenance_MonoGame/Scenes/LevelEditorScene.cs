using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Mime;
using System.Text;
using System.Threading.Tasks;
using System.Reflection.Emit;
using Vector2 = System.Numerics.Vector2;
using System.Xml.Linq;
using System.IO;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace Soutenance_MonoGame
{
    class LevelEditorScene : Scene
    {
        List<IEntity> templates = new List<IEntity>();
        int selectedTemplate = 0;
        List<IEntity> placedElements = new List<IEntity>();

        Text tutorial;
        Text selectedTemplateText;
        Button writeButton;

        FileStream fs;
        JsonWriterOptions writerOptions = new JsonWriterOptions {
            Indented = true
        };
        Utf8JsonWriter writer;

    public LevelEditorScene(string pName) : base(pName)
        {
        }

        public override void Load()
        {
            base.Load();

            templates.Add(new BrickBrickUnbreakable(Brick.BrickTypes.littlebrick, Brick.Colors.grey, "littlebrick_BrickUnbreakable"));
            templates.Add(new BrickBrickUnbreakable(Brick.BrickTypes.brick, Brick.Colors.grey, "brick_BrickUnbreakable"));
            templates.Add(new BrickBrickUnbreakable(Brick.BrickTypes.bigbrick, Brick.Colors.grey, "bigbrick_BrickUnbreakable"));
            templates.Add(new BrickPowerUp(Brick.BrickTypes.powerupbrick, Brick.Colors.green, "powerupbrick_powerup"));
            templates.Add(new BrickNormal(Brick.BrickTypes.littlebrick, Brick.Colors.green, "littlebrick_normal"));
            templates.Add(new BrickNormal(Brick.BrickTypes.brick, Brick.Colors.green, "brick_normal"));
            templates.Add(new BrickNormal(Brick.BrickTypes.bigbrick, Brick.Colors.green, "bigbrick_normal"));
            templates.Add(new BrickMoving(Brick.BrickTypes.littlebrick, Brick.Colors.green, "littlebrick_moving", new Vector2(-200.0f, 200.0f)));
            templates.Add(new BrickMoving(Brick.BrickTypes.brick, Brick.Colors.green, "brick_moving", new Vector2(-200.0f, 200.0f)));
            templates.Add(new BrickMoving(Brick.BrickTypes.bigbrick, Brick.Colors.green, "bigbrick_moving", new Vector2(-200.0f, 200.0f)));

            tutorial = new Text(new Vector2(Utils.GetScreenCenter().X, Utils.GetScreenSize().Y - 50.0f), "Space to switch elements // left click to place", "tutorial", Text.FontType.normal, Color.White);
            selectedTemplateText = new Text(new Vector2(Utils.GetScreenCenter().X, Utils.GetScreenSize().Y - 100.0f), $"{templates[selectedTemplate].GetType()}", "currentTemplate", Text.FontType.normal, Color.White);
            writeButton = new Button(Utils.GetScreenSize() - new Vector2(100.0f), Button.Colors.green, "button_write", "Save Level", Text.FontType.normal, Color.Black, WriteJson);

            Debug.WriteLine($"{name} scene has been loaded.");
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            IEntity template = templates[selectedTemplate];
            Vector2 mousePos = Utils.GetMousePosition();

            template.SetPosition(mousePos - template.GetSize() * 0.5f);

            if (ServiceLocator.GetService<IInputManager>().KeyPressed(Keys.Space))
            {
                selectedTemplate = (selectedTemplate + 1) % templates.Count;
                selectedTemplateText.value = templates[selectedTemplate].GetType().ToString();
            }

            if (ServiceLocator.GetService<IInputManager>().MouseKeyPressed(0))
            {
                IEntity element = null;
                Array colors = Enum.GetValues<Brick.Colors>();
                Random rand = new Random();

                string type = "";
                if (template.GetName().Contains("_"))
                    type = template.GetName().Split('_')[0];
                else
                    type = "teleporter";

                if (template.GetType() == typeof(BrickBrickUnbreakable))
                {
                    element = new BrickBrickUnbreakable(
                        type,
                        Brick.Colors.grey,
                        "brickBrickUnbreakable_" + placedElements.Count,
                        template.GetPosition());
                }
                else if (template.GetType() == typeof(BrickPowerUp))
                {
                    element = new BrickPowerUp(
                        type,
                        (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)),
                        "brickpowerup_" + placedElements.Count,
                        template.GetPosition());
                }
                else if (template.GetType() == typeof(BrickNormal))
                {
                    element = new BrickNormal(
                        type,
                        (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)),
                        "bricknormal_" + placedElements.Count,
                        template.GetPosition());
                }
                else if (template.GetType() == typeof(BrickMoving))
                {
                    element = new BrickMoving(
                        type,
                        (Brick.Colors)colors.GetValue(rand.Next(1, colors.Length)),
                        "brickmoving_" + placedElements.Count,
                        new Vector2(rand.Next(-200, 200), 0.0f),
                        template.GetPosition());
                }
                placedElements.Add(element);
            }
        }

        public override void Draw()
        {
            MainGame.spriteBatch.Begin(SpriteSortMode.FrontToBack);
            templates[selectedTemplate].Draw();
            foreach (IEntity entity in placedElements)
            {
                entity.Draw();
            }
            tutorial.Draw();
            selectedTemplateText.Draw();
            writeButton.Draw();
            MainGame.spriteBatch.End();
        }

        void WriteJson(int z)
        {
            List<Level> levels = ServiceLocator.GetService<ILevelManager>().GetLevels();
            char sep = Path.DirectorySeparatorChar;
#if DEBUG
            fs = File.Create($"{Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName}{sep}Levels{sep}LevelDesign.json");
#else
            fs = File.Create($"{Directory.GetCurrentDirectory()}{sep}Levels{sep}LevelDesign.json");
#endif
            writer = new Utf8JsonWriter(fs, writerOptions);

            writer.WriteStartObject();
            writer.WriteStartObject("Levels");
            for (int i = 0; i < levels.Count; i++)
            {
                writer.WriteStartObject(i.ToString());
                List<JsonNode> elements = levels[i].GetLevelElements();
                for (int a = 0; a < elements.Count; a++)
                {
                    writer.WriteStartObject(a.ToString());
                    if (elements[a]["class"].ToString().Contains("Brick"))
                    {
                        writer.WriteString("class", elements[a]["class"].ToString());
                        writer.WriteString("type", elements[a]["type"].ToString());
                        writer.WriteNumber("posX", float.Parse(elements[a]["posX"].ToString()));
                        writer.WriteNumber("posY", float.Parse(elements[a]["posY"].ToString()));
                    }
                    else if (elements[a]["class"].ToString().Contains("Teleporter"))
                    {
                        writer.WriteString("class", elements[a]["class"].ToString());
                        writer.WriteNumber("posX", float.Parse(elements[a]["posX"].ToString()));
                        writer.WriteNumber("posY", float.Parse(elements[a]["posY"].ToString()));
                        writer.WriteNumber("rotation", float.Parse(elements[a]["rotation"].ToString()));
                        writer.WriteString("destinationName", "");
                        writer.WriteNumber("newDirectionX", float.Parse(elements[a]["posX"].ToString()));
                        writer.WriteNumber("newDirectionY", float.Parse(elements[a]["posY"].ToString()));
                        writer.WriteString("name", a.ToString());
                        writer.WriteString("active", "true");
                        /*
                         * 
                "class": "teleporter",
                "posX": 350,
                "posY": 400,
                "rotation": 90,
                "destinationName": "portal_02",
                "newDirectionX": 0,
                "newDirectionY": 1,
                "name": "portal_01",
                "active": true,
                "othersToActivate": {
                    "0": "portal_02",
                    "1": "portal_04"
                }
                         */
                    }
                    writer.WriteEndObject();
                }
                writer.WriteEndObject();
            }
            writer.WriteStartObject(levels.Count.ToString());
            for (int y = 0; y < placedElements.Count; y++)
            {
                writer.WriteStartObject(y.ToString());
                IEntity entity = placedElements[y];
                if (entity.GetType().ToString().Contains("Brick"))
                {
                    Brick brick = entity as Brick;
                    writer.WriteString("class", entity.GetType().ToString().Split('.')[1]);
                    writer.WriteString("type", brick.type.ToString());
                    writer.WriteNumber("posX", entity.GetPosition().X);
                    writer.WriteNumber("posY", entity.GetPosition().Y);
                }
                else if (entity.GetType().ToString().Contains("Teleporter"))
                {

                }
                writer.WriteEndObject();
            }
            writer.WriteEndObject();
            writer.WriteEndObject();
            writer.WriteEndObject();
            writer.Flush();

            fs.Close();

            ServiceLocator.GetService<ISceneManager>().SetCurrentScene(typeof(MenuScene));
        }
    }
}
