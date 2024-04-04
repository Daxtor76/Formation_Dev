﻿using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public abstract class Scene
    {
        public string name;

        public Scene(string pName)
        {
            name = pName;
        }

        public virtual void Load()
        {
            Start();
        }

        public virtual void Start()
        {
        }

        public virtual void Update(GameTime gameTime)
        {
        }

        public virtual void Draw()
        {
        }

        public virtual void Unload()
        {
        }
    }
}
