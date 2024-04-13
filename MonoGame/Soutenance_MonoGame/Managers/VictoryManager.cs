using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using System.Text;
using System.Threading.Tasks;

namespace Soutenance_MonoGame
{
    public class VictoryManager
    {
        int ballsAmount;
        int bricksAmount;

        int playerMaxLife;
        int playerlife;

        int bouncesCount;
        float gameDuration;


        public VictoryManager()
        {
            ballsAmount = ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<Ball>().Count;
            bricksAmount = ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<BrickNormal>().Count 
                + ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<BrickMoving>().Count
                + ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<BrickPowerUp>().Count;
            playerMaxLife = 3;
            playerlife = playerMaxLife;
        }

        public void StoreGameData()
        {
            ISaveManager saveManager = ServiceLocator.GetService<ISaveManager>();

            saveManager.SetInt("life", playerlife);
            saveManager.SetInt("bounces", bouncesCount);
            saveManager.SetFloat("gameDuration", gameDuration);
        }

        public int GetDetroyableBricksCount()
        {
            return ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<BrickNormal>().Count
                + ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<BrickMoving>().Count
                + ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<BrickPowerUp>().Count;
        }

        public float GetGameDuration()
        {
            return gameDuration;
        }

        public void AddGameDuration(float duration)
        {
            gameDuration += duration;
        }

        public int GetBouncesCount()
        {
            return bouncesCount;
        }

        public void AddBounce(int amount)
        {
            bouncesCount += amount;
        }

        public int GetPlayerLife()
        {
            return playerlife;
        }

        public void DecreasePlayerLife(int amount)
        {
            playerlife -= amount;
        }

        public bool Victory()
        {
            return GetDetroyableBricksCount() == 0;
        }
    }
}
