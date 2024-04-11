using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public interface ILevelManager
    {
        public void ChangeLevel(int levelId);
        public Level GetCurrentLevel();
        public List<Level> GetLevels();
    }
}
