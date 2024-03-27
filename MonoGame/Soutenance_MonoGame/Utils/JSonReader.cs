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
    }
}
