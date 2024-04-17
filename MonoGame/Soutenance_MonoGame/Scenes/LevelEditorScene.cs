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

        void WriteJson(int i)
        {
            fs = File.Create($"E:\\Projets\\Formation_Dev\\MonoGame\\Soutenance_MonoGame\\test.json");
            writer = new Utf8JsonWriter(fs, writerOptions);

            writer.WriteStartObject();
            writer.WriteStartObject("0");
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
                writer.WriteEndObject();
            }
            writer.WriteEndObject();
            writer.WriteEndObject();
            writer.Flush();
        }
    }
}
