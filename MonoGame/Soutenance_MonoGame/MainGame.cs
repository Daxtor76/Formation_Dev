using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using System;
using System.Diagnostics;
using System.Net.Security;
using Soutenance_MonoGame.Controllers;
using Microsoft.Xna.Framework.Content;

namespace Soutenance_MonoGame
{
    public class MainGame : Game
    {
        public static GraphicsDeviceManager _graphics { get; private set; }
        public static SpriteBatch _spriteBatch { get; private set; }
        public static ContentManager _content { get; private set; }
        public static bool debugMode = true;

        public MainGame()
        {
            _graphics = new GraphicsDeviceManager(this);
            _content = Content;
            _content.RootDirectory = "Content";
            IsMouseVisible = true;
        }

        private void SetGameFullScreen(bool isFull)
        {
            _graphics.ApplyChanges();
            _graphics.PreferredBackBufferWidth = isFull ? GraphicsAdapter.DefaultAdapter.CurrentDisplayMode.Width : 1280;
            _graphics.PreferredBackBufferHeight = isFull ? GraphicsAdapter.DefaultAdapter.CurrentDisplayMode.Height : 720;
            _graphics.IsFullScreen = isFull;
            _graphics.ApplyChanges();
        }

        protected override void Initialize()
        {
            // TODO: Add your initialization logic here
            SetGameFullScreen(false);
            SceneController.Init();

            base.Initialize();
        }

        protected override void LoadContent()
        {
            _spriteBatch = new SpriteBatch(GraphicsDevice);

            // TODO: use this.Content to load your game content here
        }

        protected override void Update(GameTime gameTime)
        {
            if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
                Exit();

            // TODO: Add your update logic here
            if(SceneController.currentScene != null)
                SceneController.currentScene.Update(gameTime);

            base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime)
        {
            GraphicsDevice.Clear(Color.Black);

            // TODO: Add your drawing code here
            if(SceneController.currentScene != null)
            {
                _spriteBatch.Begin();
                SceneController.currentScene.Draw();
                _spriteBatch.End();
            }

            base.Draw(gameTime);
        }
    }
}
