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

        // TO DO: pour faire un vrai service locator, faire un deuxième service de sprites qui marche pas pareil, qui ne renvoie pas la même chose etc
        // Choisir le service de sprite avec un random

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
