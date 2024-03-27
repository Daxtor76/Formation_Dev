using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public interface ISceneManager
    {
        public void Init();
        public void SetCurrentScene(Type sceneType);
        public Scene GetCurrentScene();
    }
}
