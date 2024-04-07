using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
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

        public VictoryManager()
        {
            ballsAmount = ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<Ball>().Count;
            bricksAmount = ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<BrickNormal>().Count 
                + ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<BrickMoving>().Count
                + ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<BrickPowerUp>().Count;
            playerMaxLife = 3;
            playerlife = playerMaxLife;
        }

        public int GetDetroyableBricksCount()
        {
            return ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<BrickNormal>().Count
                + ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<BrickMoving>().Count
                + ServiceLocator.GetService<IEntityManager>().GetEntitiesOfType<BrickPowerUp>().Count;
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
