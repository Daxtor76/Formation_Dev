using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public interface ISaveManager
    {
        public void SetFloat(string keyName, float value);
        public float GetFloat(string keyName);
        public void SetInt(string keyName, int value);
        public int GetInt(string keyName);
        public void SetString(string keyName, string value);
        public string GetString(string keyName);
    }
}
