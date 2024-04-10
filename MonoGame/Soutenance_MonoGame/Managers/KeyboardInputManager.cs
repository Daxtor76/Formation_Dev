﻿using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class KeyboardInputManager : IInputManager
    {
        bool pressed = false;
        MouseState previousMouseState;
        MouseState currentMouseState = Mouse.GetState();
        public KeyboardInputManager()
        {
            ServiceLocator.RegisterService<IInputManager>(this);
        }

        public bool MouseKeyDown(int buttonID)
        {
            if (buttonID == 1)
            {
                return Mouse.GetState().RightButton == ButtonState.Pressed;
            }

            return Mouse.GetState().LeftButton == ButtonState.Pressed;
        }

        public bool MouseKeyPressed(int buttonID)
        {
            previousMouseState = currentMouseState;

            currentMouseState = Mouse.GetState();
            if (buttonID == 0)
            {
                if (previousMouseState.LeftButton == ButtonState.Released && currentMouseState.LeftButton == ButtonState.Pressed)
                {
                    return true;
                }
                return false;
            }
            else if (buttonID == 1)
            {
                if (previousMouseState.RightButton == ButtonState.Released && currentMouseState.RightButton == ButtonState.Pressed)
                {
                    return true;
                }
                return false;
            }
            else
                return false;
        }

        public bool KeyDown(Keys key)
        {
            return Keyboard.GetState().IsKeyDown(key);
        }

        public bool KeyPressed(Keys key)
        {
            if (!pressed && Keyboard.GetState().IsKeyDown(key))
            {
                pressed = true;
                return true;
            }
            else
            {
                if (Keyboard.GetState().IsKeyUp(key))
                    pressed = false;
                return false;
            }
        }

        public Vector2 GetInputDirection()
        {
            Vector2 direction = new Vector2();

            if (KeyDown(Keys.D))
                direction.X = 1;
            else if (KeyDown(Keys.Q))
                direction.X = -1;

            return direction;
        }
    }
}
