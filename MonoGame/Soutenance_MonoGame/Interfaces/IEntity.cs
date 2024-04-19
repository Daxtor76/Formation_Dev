using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;
using Vector2 = System.Numerics.Vector2;

namespace Soutenance_MonoGame
{
    public interface IEntity
    {
        public void Start();
        public string GetName();
        public void SetName(string name);
        public float GetRotation();
        public void SetRotation(float pRotation);
        public void SetPosition(Vector2 position);
        public void SetScale(Vector2 scale);
        public Vector2 GetPosition();
        public Vector2 GetSize();
        public void Update(GameTime gameTime);
        public void Draw();
        public void Unload();
        public bool IsEnabled();
        public void SetEnabled(bool value);
        public bool IsActive();
        public void SetActive(bool value);
        public void SetLayerDepth(float value);
        public float GetLayerDepth();
        public Vector2 GetNewDirection();
    }
}
