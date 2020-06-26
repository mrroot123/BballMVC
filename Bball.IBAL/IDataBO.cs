using BballMVC.DTOs;
using BballMVC.IDTOs;

namespace Bball.IBAL
{
   public interface IDataBO
   {
      void GetLeagueNames(IBballInfoDTO oBballInfoDTO);
      void GetLeagueData(IBballInfoDTO oBballInfoDTO);
   }
}