using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    sealed class LevelManager : ILevelManager
    {
        List<Level> levels = new List<Level>();
        int currentLevelId = 0;
        public LevelManager()
        {
            levels = LoadLevels();
            ServiceLocator.RegisterService<ILevelManager>(this);
        }

        public List<Level> LoadLevels()
        {
            List<Level> list = new List<Level>();

            list.Add(new Level(10, 10));

            return list;
        }

        public void SetCurrentLevel(int levelId)
        {
            UnloadCurrentLevel();
            currentLevelId = levelId;
        }

        public Level GetCurrentLevel()
        {
            return levels[currentLevelId] != null ? levels[currentLevelId] : levels[0];
        }

        public void UnloadCurrentLevel()
        {
            if (levels[currentLevelId] != null)
                levels[currentLevelId].Unload();
        }
    }
}
