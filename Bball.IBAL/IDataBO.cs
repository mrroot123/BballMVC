using BballMVC.DTOs;
using BballMVC.IDTOs;

namespace Bball.IBAL
{
   public interface IDataBO
   {
     // void GetLeagueNames(IBballInfoDTO oBballInfoDTO);
     // void GetLeagueData(IBballInfoDTO oBballInfoDTO);
      //void GetBoxScoresSeeds(IBballInfoDTO oBballInfoDTO);
      void PostData(string strJObject, string CollectionType);
      void GetData(IBballInfoDTO oBballInfoDTO);
      //void RefreshTodaysMatchups(IBballInfoDTO oBballInfoDTO);
   }
}