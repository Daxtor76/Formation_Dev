using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class SaveManager : ISaveManager
    {
        public Dictionary<string, float> playerPrefsFloats = new Dictionary<string, float>();
        public Dictionary<string, int> playerPrefsInts = new Dictionary<string, int>();
        public Dictionary<string, string> playerPrefsStrings = new Dictionary<string, string>();

        public SaveManager()
        {
            ServiceLocator.RegisterService<ISaveManager>(this);
        }

        public void ClearData()
        {
            playerPrefsFloats.Clear();
            playerPrefsInts.Clear();
            playerPrefsStrings.Clear();
        }

        public void SetFloat(string keyName, float value)
        {
            playerPrefsFloats[keyName] = value;
        }

        public float GetFloat(string keyName)
        {
            return playerPrefsFloats[keyName];
        }

        public void SetInt(string keyName, int value)
        {
            playerPrefsInts[keyName] = value;
        }

        public int GetInt(string keyName)
        {
            return playerPrefsInts[keyName];
        }

        public void SetString(string keyName, string value)
        {
            playerPrefsStrings[keyName] = value;
        }

        public string GetString(string keyName)
        {
            return playerPrefsStrings[keyName];
        }
    }
}
