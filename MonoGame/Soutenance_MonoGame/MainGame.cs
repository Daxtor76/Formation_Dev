using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using System;
using System.Diagnostics;
using System.Net.Security;
using Microsoft.Xna.Framework.Content;

namespace Soutenance_MonoGame
{
    public class MainGame : Game
    {
        public static GraphicsDeviceManager graphics { get; private set; }
        public static SpriteBatch spriteBatch { get; private set; }
        public static ContentManager content { get; private set; }
        public static bool debugMode = true;

        public MainGame()
        {
            graphics = new GraphicsDeviceManager(this);
            content = Content;
            content.RootDirectory = "Content";
            IsMouseVisible = true;
            SetGameScreen(false);
        }

        private void SetGameScreen(bool isFull)
        {
            graphics.ApplyChanges();
            graphics.IsFullScreen = isFull;
            graphics.PreferredBackBufferWidth = isFull ? GraphicsAdapter.DefaultAdapter.CurrentDisplayMode.Width : 1280;
            graphics.PreferredBackBufferHeight = isFull ? GraphicsAdapter.DefaultAdapter.CurrentDisplayMode.Height : 720;
            graphics.ApplyChanges();
        }

        protected override void Initialize()
        {
            // TODO: Add your initialization logic here
            new EntityManager();
            new CollisionManager();
            new KeyboardInputManager();
            new SpritesManager();
            new LevelManager();
            new SceneManager();

            base.Initialize();
        }

        protected override void LoadContent()
        {
            spriteBatch = new SpriteBatch(GraphicsDevice);

            // TODO: use this.Content to load your game content here
        }

        protected override void Update(GameTime gameTime)
        {
            if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
                Exit();

            // TODO: Add your update logic here
            if(ServiceLocator.GetService<ISceneManager>().GetCurrentScene() != null)
                ServiceLocator.GetService<ISceneManager>().GetCurrentScene().Update(gameTime);

            base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime)
        {
            GraphicsDevice.Clear(Color.Black);

            // TODO: Add your drawing code here
            if(ServiceLocator.GetService<ISceneManager>().GetCurrentScene() != null)
            {
                spriteBatch.Begin();
                ServiceLocator.GetService<ISceneManager>().GetCurrentScene().Draw();
                spriteBatch.End();
            }

            base.Draw(gameTime);
        }
    }
}
