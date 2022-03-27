using BballMVC.DTOs;
using BballMVC.IDTOs;
using Newtonsoft.Json.Linq;
using System.Threading.Tasks;

namespace Bball.IBAL
{
   public interface IDataBO
   {
      // void GetLeagueNames(IBballInfoDTO oBballInfoDTO);
      // void GetLeagueData(IBballInfoDTO oBballInfoDTO);
      //void GetBoxScoresSeeds(IBballInfoDTO oBballInfoDTO);
      void PostData(IBballInfoDTO oBballInfoDTO);
      Task GetDataAsync(IBballInfoDTO oBballInfoDTO);
      void GetData(IBballInfoDTO oBballInfoDTO);
      string SqlToJson(string RequestType, string Parms, string ConnectionString);
      //void RefreshTodaysMatchups(IBballInfoDTO oBballInfoDTO);
   }
}