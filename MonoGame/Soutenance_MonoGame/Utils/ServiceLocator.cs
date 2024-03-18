using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public static class ServiceLocator
    {
        private static readonly Dictionary<Type, object> _services = new Dictionary<Type, object>();

        public static void RegisterService<T>(T service)
        {
            _services.Add(typeof(T), service);
        }

        public static T GetService<T>()
        {
            return (T)_services[typeof(T)];
        }
    }
}
