﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public interface IEntity
    {
        public void Start();
        public string GetName();
        public void SetName(string name);
        public void SetPosition(Vector2 position);
        public void SetScale(Vector2 scale);
        public Vector2 GetPosition();
        public Vector2 GetSize();
        public void Unload();
        public bool IsEnabled();
        public void SetEnabled(bool value);
        public bool IsActive();
        public void SetActive(bool value);
    }
}