using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.Json.Nodes;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public static class JSonReader
    {
        public static string ReadFile(string path)
        {
            string fileContent = File.ReadAllText(path).TrimEnd('\n');

            return fileContent;
        }

        public static JsonNode Deserialize(string path)
        {
            string jsonString = ReadFile(path);
            JsonNode jsonNode = JsonNode.Parse(jsonString).AsObject();

            return jsonNode;
        }

        /* Exemple
            JsonNode ld = JSonReader.Deserialize("E:\\Projets\\Formation_Dev\\MonoGame\\Soutenance_MonoGame\\Levels\\LevelDesign.json");
            JsonNode ldLevels = ld["Levels"];

            for (int i = 0; i < ldLevels.AsObject().Count; i++)
            {
                Debug.WriteLine($"Level {i}: {ldLevels[i.ToString()]["sizeX"]}");
            }
         */
    }
}
