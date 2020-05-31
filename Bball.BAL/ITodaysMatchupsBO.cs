using System.Collections.Generic;
using BballMVC.IDTOs;

namespace Bball.BAL
{
   public interface ITodaysMatchupsBO
   {
      void GetTodaysMatchups(IList<ITodaysMatchupsDTO> ocTodaysMatchupsDTO);
   }
}