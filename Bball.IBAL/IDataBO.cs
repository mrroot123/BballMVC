using BballMVC.DTOs;
using BballMVC.IDTOs;
using Newtonsoft.Json.Linq;

namespace Bball.IBAL
{
   public interface IDataBO
   {
      // void GetLeagueNames(IBballInfoDTO oBballInfoDTO);
      // void GetLeagueData(IBballInfoDTO oBballInfoDTO);
      //void GetBoxScoresSeeds(IBballInfoDTO oBballInfoDTO);
      void PostData(IBballInfoDTO oBballInfoDTO);
      void GetData(IBballInfoDTO oBballInfoDTO);
      //void RefreshTodaysMatchups(IBballInfoDTO oBballInfoDTO);
   }
}