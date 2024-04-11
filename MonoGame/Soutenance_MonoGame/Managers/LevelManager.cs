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
                JsonNode ld = JSonReader.Deserialize($"{Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName}{sep}Levels{sep}{fileName}.json");
                if (ld["Levels"] != null)
                {
                    JsonNode ldLevels = ld["Levels"];
                    for (int i = 0; i < ldLevels.AsObject().Count; i++)
                    {
                        int lvlSizeX = (int)ldLevels[i.ToString()]["sizeX"];
                        int lvlSizeY = (int)ldLevels[i.ToString()]["sizeY"];

                        list.Add(new Level(lvlSizeX, lvlSizeY));
                        Debug.WriteLine($"Level {i} ({lvlSizeX}/{lvlSizeY}) loaded.");
                    }
                }
            }
            else
            {
                Random rand = new Random();
                list.Add(new Level(rand.Next(1, 10), rand.Next(1, 10)));
            }

            return list;
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
