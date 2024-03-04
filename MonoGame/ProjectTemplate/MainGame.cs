using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using System;
using System.Diagnostics;
using System.Net.Security;
using ProjectTemplate.Controllers;

namespace ProjectTemplate
{
    public class MainGame : Game
    {
        public GraphicsDeviceManager _graphics { get; private set; }
        public SpriteBatch _spriteBatch { get; private set; }

        public MainGame()
        {
            _graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
            IsMouseVisible = true;
        }

        protected override void Initialize()
        {
            // TODO: Add your initialization logic here
            SceneController.Init(this);

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
                SceneController.currentScene.Draw(gameTime);
                _spriteBatch.End();
            }

            base.Draw(gameTime);
        }
    }
}
