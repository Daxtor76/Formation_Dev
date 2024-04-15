using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

namespace Soutenance_MonoGame
{
    sealed class LevelManager : ILevelManager
    {
        List<Level> levels = new List<Level>();
        int currentLevelId = 0;
        public LevelManager()
        {
            levels = LoadLevelsFromJSon("LevelDesign");
            ServiceLocator.RegisterService<ILevelManager>(this);
        }

        public List<Level> LoadLevelsFromJSon(string fileName = null)
        {
            List<Level> list = new List<Level>();
            if (fileName != null)
            {
                char sep = Path.DirectorySeparatorChar;
#if DEBUG
                JsonNode ld = JSonReader.Deserialize($"{Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName}{sep}Levels{sep}{fileName}.json");
#else
                JsonNode ld = JSonReader.Deserialize($"{Directory.GetCurrentDirectory()}{sep}Levels{sep}{fileName}.json");
#endif
                if (ld["Levels"] != null)
                {
                    JsonNode ldLevels = ld["Levels"];
                    for (int i = 0; i < ldLevels.AsObject().Count; i++)
                    {
                        JsonNode elements = ldLevels[i.ToString()];
                        List<JsonNode> levelElements = new List<JsonNode>();
                        for (int y = 0; y < elements.AsObject().Count; y++)
                        {
                            levelElements.Add(elements[y.ToString()]);
                        }
                        
                        list.Add(new Level(levelElements));
                        Debug.WriteLine($"Level {i} loaded with {levelElements.Count} elements");
                    }
                }
            }

            return list;
        }

        public Level GetLevel(int id)
        {
            return id < levels.Count && id >= 0 ? levels[id] : null;
        }

        public List<Level> GetLevels()
        {
            return levels;
        }

        public void ChangeLevel(int levelId)
        {
            if (levels[levelId] != null)
            {
                GetCurrentLevel().Unload();

                ServiceLocator.GetService<ISaveManager>().SetInt("lastLevelPlayed", levelId);

                SetCurrentLevel(levelId);
                GetCurrentLevel().GenerateGrid();
            }
            else
                Debug.WriteLine($"Level {levelId} does not exist.");
        }

        public Level GetCurrentLevel()
        {
            return levels[currentLevelId] != null ? levels[currentLevelId] : levels[0];
        }

        void SetCurrentLevel(int levelId)
        {
            currentLevelId = levelId;
        }
    }
}
